import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts--display"
export default class extends Controller {

  static values = { userId: Number }

  connect() {
    const labels = JSON.parse(this.element.dataset.chartLabels)
    const data = JSON.parse(this.element.dataset.chartData)

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
        responsive: true,
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
      this.chart.data.labels = Array.from(labels);
      this.chart.data.datasets[0].data = Array.from(data);
      this.chart.update();
    } catch(err) {
      console.log("response error");
    }
  }
}
