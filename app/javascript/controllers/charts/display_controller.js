import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts--display"
export default class extends Controller {

  static values = { userId: Number }

  connect() {
    const labels = JSON.parse(this.element.dataset.chartLabels)
    const data = JSON.parse(this.element.dataset.chartData)
    const uneasy = JSON.parse(this.element.dataset.chartUneasyFlags)

    // グラフの縦横幅
    this.fixedHeight = 320
    this.defaultWidth = 253

    document.getElementById('myChart').style.width = this.defaultWidth+"px";
    document.getElementById('myChart').style.height = this.fixedHeight+"px";

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
          pointBackgroundColor: (c) => uneasy[c.dataIndex] ? "#eb6ea5" : "#25625d",
          pointRadius: (c) => uneasy[c.dataIndex] ? 4 : 1.5,
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

  async update(e) {
    const range = e.target.value;
    const url = `/users/${this.userIdValue}/chart/data?range=${range}`;

    try {
      const res = await fetch(url);
      const json = await res.json();
      const { labels, data } = json;

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
        const scrollableWidth = data.length*widthEachData
        document.getElementById('myChart').style.width = scrollableWidth+"px";
        this.chart.resize(scrollableWidth, this.fixedHeight)
      } else {
        // 固定された横幅の設定
        this.chart.resize(this.defaultWidth, this.fixedHeight)
      }

      // グラフ内のデータの更新
      this.chart.data.labels = Array.from(labels);
      this.chart.data.datasets[0].data = Array.from(data);
      this.chart.update();
    } catch(err) {
      console.log("response error");
    }
  }
}
