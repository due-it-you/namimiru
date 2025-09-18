import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="daily-records--mood-score"
export default class extends Controller {
  connect() {
    const currentMoodScore = document.getElementById("mood-range").value;
    const target = document.getElementById("current-mood-score");
    target.textContent = currentMoodScore;
  }

  update() {
    const currentMoodScore = document.getElementById("mood-range").value;
    const target = document.getElementById("current-mood-score");
    target.textContent = currentMoodScore;
  }
}
