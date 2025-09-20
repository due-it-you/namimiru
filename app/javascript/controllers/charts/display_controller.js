import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts--display"
export default class extends Controller {
  connect() {
    const labels = JSON.parse(this.element.dataset.chartLabels)
    const data = JSON.parse(this.element.dataset.chartData)

    const ctx = document.getElementById('myChart');

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: '',
          data: data,
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });
  }
}
