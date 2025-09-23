import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="daily-records--mood-score"
export default class extends Controller {
  connect() {
    const currentMoodScore = document.getElementById("mood-range").value;
    const currentMoodTarget = document.getElementById("current-mood");
    const currentMoodIconTarget = document.getElementById("current-mood-icon");
    const currentMoodScoreTarget = document.getElementById("current-mood-score");
    const labels = {
      "-5": ["絶不調", "😵‍💫"],
      "-4": ["とてもつらい", "😖"],
      "-3": ["つらい", "😔"],
      "-2": ["ややつらい", "🙁"],
      "-1": ["少しつらい", "😐"],
      "0": ["普通", "🙂"],
      "1": ["少し良い", "😌"],
      "2": ["良い", "😄"],
      "3": ["けっこう良い", "😆"],
      "4": ["とても良い", "🥳"],
      "5": ["絶好調", "🤩"]
    };
    const currentMood = labels[currentMoodScore][0];
    const currentMoodIcon = labels[currentMoodScore][1];

    currentMoodTarget.textContent = currentMood;
    currentMoodIconTarget.textContent = currentMoodIcon;
    currentMoodScoreTarget.textContent = currentMoodScore;
  }

  update() {
    const currentMoodScore = document.getElementById("mood-range").value;
    const currentMoodTarget = document.getElementById("current-mood");
    const currentMoodScoreTarget = document.getElementById("current-mood-score");
    const currentMoodIconTarget = document.getElementById("current-mood-icon");
    const labels = {
      "-5": ["絶不調", "😵‍💫"],
      "-4": ["とてもつらい", "😖"],
      "-3": ["つらい", "😔"],
      "-2": ["ややつらい", "🙁"],
      "-1": ["少しつらい", "😐"],
      "0": ["普通", "🙂"],
      "1": ["少し良い", "😌"],
      "2": ["良い", "😄"],
      "3": ["けっこう良い", "😆"],
      "4": ["とても良い", "🥳"],
      "5": ["絶好調", "🤩"]
    };
    const currentMood = labels[currentMoodScore][0];
    const currentMoodIcon = labels[currentMoodScore][1];

    currentMoodTarget.textContent = currentMood;
    currentMoodIconTarget.textContent = currentMoodIcon;
    currentMoodScoreTarget.textContent = currentMoodScore;
  }
}
