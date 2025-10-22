import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="range-slider--current-mood"
export default class extends Controller {
  connect() {
    const slider = document.getElementById("mood-range")
    const currentMoodScore = slider.value
    const activeColor = {
      "-5": "#2F3B56", // 絶不調 
      "-4": "#3A4A6B", //とてもつらい
      "-3": "#4F6A88", //つらい
      "-2": "#6599A0", //ややつらい
      "-1": "#5EADA9", //少しつらい
      "0": "#67BDB7", //普通
      "1": "#74C6A0", //少し良い
      "2": "#97D07F", //良い
      "3": "#C6DB67", //けっこう良い
      "4": "#F1C04F", //とても良い
      "5": "#F58A3A" //絶好調
    }
    const baseColor = "#dcdcdc"
    const currentActiveColor = activeColor[currentMoodScore]
    const progress = ((slider.value - slider.min) / (slider.max - slider.min)) * 100
    slider.style.background = `linear-gradient(90deg, ${currentActiveColor} ${progress}%, ${baseColor} ${progress}%)`
  }

  updateColor(e) {
    const slider = e.target
    const currentMoodScore = e.target.value
    const activeColor = {
      "-5": "#2F3B56", // 絶不調 
      "-4": "#3A4A6B", //とてもつらい
      "-3": "#4F6A88", //つらい
      "-2": "#6599A0", //ややつらい
      "-1": "#5EADA9", //少しつらい
      "0": "#67BDB7", //普通
      "1": "#74C6A0", //少し良い
      "2": "#97D07F", //良い
      "3": "#C6DB67", //けっこう良い
      "4": "#F1C04F", //とても良い
      "5": "#F58A3A" //絶好調
    }
    const baseColor = "#dcdcdc"
    const currentActiveColor = activeColor[currentMoodScore]

    const progress = ((currentMoodScore - slider.min) / (slider.max - slider.min)) * 100
    slider.style.background = `linear-gradient(90deg, ${currentActiveColor} ${progress}%, ${baseColor} ${progress}%)`
  }
}
