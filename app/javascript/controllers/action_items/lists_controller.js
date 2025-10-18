import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--lists"
export default class extends Controller {
  static targets = ["listsFrame"]

  connect() {
  }

  update(e) {
    const frame = this.listsFrameTarget;
    const tagsList = Array.from(document.getElementById("present-tags-list").children)
    let activeTagName;
    tagsList.forEach((tag) => {
      if (tag.active) {
        activeTagName = tag.textContent.trim().replace(/^# /, "")
      }
    })
    // もしnullなら空文字に変換
    const name = activeTagName ?? "";
    frame.src = `/action_items?mood_score=${e.target.value}&selected_tag_name=${name}`
  }
}
