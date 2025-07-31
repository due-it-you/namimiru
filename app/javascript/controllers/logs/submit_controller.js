import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="logs--submit"
export default class extends Controller {
  static targets = ["mood_score"]

  connect() {
  }

  submitMoodScore() {
    const moodScore = this.mood_scoreTarget.value
  }
} 
