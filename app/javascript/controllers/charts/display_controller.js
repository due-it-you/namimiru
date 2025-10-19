import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts--display"
export default class extends Controller {

  static values = { userId: Number }

  connect() {
    const labels = JSON.parse(this.element.dataset.chartLabels)
    const data = JSON.parse(this.element.dataset.chartData)

    document.getElementById('myChart').style.width = "253px";
    document.getElementById('myChart').style.height = "320px";

    const ctx = document.getElementById('myChart');

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: '',
          data: data,
          borderWidth: 1,
          spanGaps: true,
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
      const fixedHeight = 320
      const defaultWidth = 253

      if (data.length >= aroundOneMonthDays) {
        const scrollableWidth = data.length*widthEachData
        document.getElementById('myChart').style.width = scrollableWidth+"px";
        this.chart.resize(scrollableWidth, fixedHeight)
      } else {
        this.chart.resize(defaultWidth, fixedHeight)
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
