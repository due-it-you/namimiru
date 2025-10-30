import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--form"
export default class extends Controller {
  connect() {
  }

  toggleMoodScoreForm(e) {
    const rangeSlider = document.getElementById("mood-range");
    const moodScoreForm = document.getElementById("input-mood-score-form");

    if (e.target.value == "avoid") {
      rangeSlider.disabled = true;
      moodScoreForm.hidden = true;
    } else if (e.target.value == "dynamic") {
      rangeSlider.disabled = false;
      moodScoreForm.hidden = false;
    }
  }
}
