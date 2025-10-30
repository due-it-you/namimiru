import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--lists"
export default class extends Controller {
  static targets = ["moodScore"]

  connect() {
    const cannotList = document.getElementById("cannot-list")
    const avoidList = document.getElementById("avoid-list")
    const moodScore = this.moodScoreTarget.value

    if (moodScore == "0") {
      cannotList.hidden = false;
      avoidList.hidden = true;
    } else if (moodScore == "1") {
      cannotList.hidden = true;
      avoidList.hidden = false;
    }
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

  toggleListsHidden(e) {
    const cannotList = document.getElementById("cannot-list")
    const avoidList = document.getElementById("avoid-list")
    const moodScore = e.target.value

    if (moodScore == "0") {
      cannotList.hidden = false;
      avoidList.hidden = true;
    } else if (moodScore == "1") {
      cannotList.hidden = true;
      avoidList.hidden = false;
    }
  }
}
