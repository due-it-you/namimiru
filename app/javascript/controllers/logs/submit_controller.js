import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="logs--submit"
export default class extends Controller {
  target = ["mood_score"]

  connect() {
  }
}
