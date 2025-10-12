import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--lists"
export default class extends Controller {
  static targets = ["listsFrame"]

  connect() {
  }

  update(e) {
    const frame = this.listsFrameTarget;
    frame.src = `/action_items?mood_score=${e.target.value}`
  }
}
