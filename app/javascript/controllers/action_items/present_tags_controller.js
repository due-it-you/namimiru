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
      if (isClicked) {
        // 選択されたタグの見た目の切り替え
        selectedTag.active = !selectedTag.active;
        selectedTag.classList.toggle("bg-orange-400")
        selectedTag.classList.toggle("text-white")
        selectedTag.classList.toggle("font-semibold")
        selectedTag.classList.toggle("border")
        selectedTag.classList.toggle("border-gray-400")
      } else {
        // 選択されたタグ以外の全てのタグを非アクティブ化
        tag.active = false;
        tag.classList.remove("bg-orange-400")
        tag.classList.remove("text-white")
        tag.classList.remove("font-semibold")
        tag.classList.add("border")
        tag.classList.add("border-gray-400")
      }});
  }

  updateLists(e) {
    const selectedTag = e.target
    const selectedTagName = e.target.textContent.trim().replace(/^# /, "")
    const frame = this.listsFrameTarget

    if (selectedTag.active) {
      // 選択されたタグに関する項目を表示
      frame.src = `/action_items?mood_score=${e.target.value}&selected_tag_name=${selectedTagName}`
    } else {
      // 全ての項目を表示
      frame.src = `/action_items?mood_score=${e.target.value}`
    }
  }
}
