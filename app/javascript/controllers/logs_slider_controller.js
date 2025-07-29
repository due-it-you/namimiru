import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="logs-slider"
export default class extends Controller {
  static targets = ["score", "output"]

  connect() {
    this.outputTarget.textContent = this.scoreTarget.value;
  }
}
