import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts--display"
export default class extends Controller {

  static values = { userId: Number }
  static targets = ["range", "selectedUser"]

  connect() {
    const labels = JSON.parse(this.element.dataset.chartLabels)
    const data = JSON.parse(this.element.dataset.chartData)
    const uneasy = JSON.parse(this.element.dataset.chartUneasyFlags)
    this.uneasyColor = "#eb6ea5"
    this.notUneasyColor = "rgba(103, 189, 183, 0.7)"
    this.uneasyFlags = uneasy.map(flag => (flag ? this.uneasyColor : this.notUneasyColor))
    this.uneasyPointRadius = 3
    this.notUneasyPointRadius = 1.5
    const pointRadius = uneasy.map(flag => (flag ? this.uneasyPointRadius : this.notUneasyPointRadius))

    // グラフの縦横幅
    this.fixedHeight = 320
    this.defaultWidth = 253

    document.getElementById('myChart').style.width = this.defaultWidth + "px";
    document.getElementById('myChart').style.height = this.fixedHeight + "px";

    const ctx = document.getElementById('myChart');

    const defaultChartLineColor = "rgba(103, 189, 183, 0.7)"

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: '',
          data: data,
          spanGaps: true,
          borderColor: defaultChartLineColor,
          backgroundColor: defaultChartLineColor,
          borderWidth: 2.5,
          pointStyle: "circle",
          pointBackgroundColor: this.uneasyFlags,
          pointRadius: pointRadius,
          fill: true,
          tension: 0.1
        }]
      },
      options: {
        responsive: false,
        maintainAspectRatio: false,
        scales: {
          y: {
            min: -5,
            max: 5,
            ticks: {
              stepSize: 1
            }
          }
        }
      }
    });
  }

  async update() {
    const range = this.rangeTarget.value
    const userId = this.selectedUserTarget.value
    const url = `/charts.json?range=${range}&user_id=${userId}`;

    try {
      const res = await fetch(url);
      const json = await res.json();
      const { labels, data, uneasy_flags } = json;

      this.uneasyFlags = uneasy_flags.map(flag => (flag ? this.uneasyColor : this.notUneasyColor))
      const pointRadius = uneasy_flags.map(flag => (flag ? this.uneasyPointRadius : this.notUneasyPointRadius))
      // 期間によってグラフのX軸をスクロール可能に変更
      const aroundOneMonthDays = 40
      const widthEachData = 4

      // 直近３ヶ月以上の期間のグラフの時にスクロール表示
      if (data.length >= aroundOneMonthDays) {
        // 右端を起点にスクロール
        const wrapper = document.querySelector('.overflow-x-scroll')
        if (wrapper) {
          requestAnimationFrame(() => {
            wrapper.scrollLeft = wrapper.scrollWidth
          })
        }
        // データ数に合わせた横幅の設定
        const scrollableWidth = data.length * widthEachData
        document.getElementById('myChart').style.width = scrollableWidth + "px";
        this.chart.resize(scrollableWidth, this.fixedHeight)
      } else {
        // 固定された横幅の設定
        this.chart.resize(this.defaultWidth, this.fixedHeight)
      }

      // グラフ内のデータの更新
      this.chart.data.labels = Array.from(labels);
      this.chart.data.datasets[0].data = Array.from(data);
      this.chart.data.datasets[0].pointBackgroundColor = Array.from(this.uneasyFlags);
      this.chart.data.datasets[0].pointRadius = Array.from(pointRadius);
      this.chart.update();

      // ユーザーネームの表示変更
      const usernameTarget = document.getElementById("username")
      usernameTarget.textContent = this.selectedUserTarget.options[this.selectedUserTarget.selectedIndex].text
    } catch (err) {
      console.log("response error");
    }
  }
}
