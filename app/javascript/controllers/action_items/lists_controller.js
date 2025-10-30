import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--lists"
export default class extends Controller {
  static targets = ["listsFrame"]

  connect() {
  }

  async update(e) {
    const moodScore = e.target.value
    const tagsList = Array.from(document.getElementById("present-tags-list").children)
    let activeTagName;
    tagsList.forEach((tag) => {
      if (tag.active) {
        activeTagName = tag.textContent.trim().replace(/^# /, "")
      }
    })
    // もしnullなら空文字に変換
    const name = activeTagName ?? "";
    const res = await fetch(
      `/action_items?mood_score=${moodScore}&selected_tag_name=${name}`,
      { headers: { Accept: "text/vnd.turbo-stream.html" } }
    )

    Turbo.renderStreamMessage(await res.text())
  }
}
