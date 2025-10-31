import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--present-tags"
export default class extends Controller {
  static targets = ["listsFrame"]

  connect() {
  }

  toggleActive(e) {
    const presentTagsList = Array.from(document.getElementById("present-tags-list").children)
    const selectedTag = e.target

    presentTagsList.forEach((tag) => {
      const isClicked = tag === selectedTag

      const backgroundColor = "bg-gray-600"
      const textColor = "text-white"
      const fontWeight = "font-semibold"
      const borderColor = "border-gray-400"

      if (isClicked) {
        // 選択されたタグの見た目の切り替え
        selectedTag.active = !selectedTag.active;
        selectedTag.classList.toggle(backgroundColor)
        selectedTag.classList.toggle(textColor)
        selectedTag.classList.toggle(fontWeight)
        selectedTag.classList.toggle("border")
        selectedTag.classList.toggle(borderColor)
      } else {
        // 選択されたタグ以外の全てのタグを非アクティブ化
        tag.active = false;
        tag.classList.remove(backgroundColor)
        tag.classList.remove(textColor)
        tag.classList.remove(fontWeight)
        tag.classList.add("border")
        tag.classList.add(borderColor)
      }
    });
  }

  async updateLists(e) {
    const moodScore = document.getElementById("mood-range").value;
    const selectedTag = e.target
    const selectedTagName = e.target.textContent.trim().replace(/^# /, "")

    if (selectedTag.active) {
      // 選択されたタグに関する項目を表示
      const res = await fetch(
        `/action_items?mood_score=${moodScore}&selected_tag_name=${selectedTagName}`,
        { headers: { Accept: "text/vnd.turbo-stream.html" } }
      )

      Turbo.renderStreamMessage(await res.text())
    } else {
      // 全ての項目を表示
      // 選択されたタグに関する項目を表示
      const res = await fetch(
        `/action_items?mood_score=${moodScore}`,
        { headers: { Accept: "text/vnd.turbo-stream.html" } }
      )

      Turbo.renderStreamMessage(await res.text())
    }
  }
}
