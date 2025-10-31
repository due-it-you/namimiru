import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-items--lists"
export default class extends Controller {
  static targets = ["moodScore"]

  connect() {
    this.count = 0
    const cannotList = document.getElementById("cannot-list")
    const avoidList = document.getElementById("avoid-list")
    const moodScore = this.moodScoreTarget.value

    // 最新の記録の気分が躁状態なら
    if (moodScore > 0) {
      // やらない方がいいリストを先に表示
      cannotList.hidden = true;
      avoidList.hidden = false;
    } else if (moodScore <= 0) {
      // できないかもリストを先に表示
      cannotList.hidden = false;
      avoidList.hidden = true;
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

  // スライダーを変動させると自動でリストを切り替える
  toggleListsHidden(e) {
    // 一度でも手動でリストを切り替えした場合、リロードしない限りスライダーを動かしても自動で切り替えされない
    if (this.count > 0) {
      return
    }
    const cannotList = document.getElementById("cannot-list")
    const avoidList = document.getElementById("avoid-list")
    const moodScore = e.target.value

    // 躁状態なら
    if (moodScore <= 0) {
      // やらない方がいいリストを表示
      cannotList.hidden = false;
      avoidList.hidden = true;
      // 鬱状態なら
    } else if (moodScore > 0) {
      // できないかもリストを表示
      cannotList.hidden = true;
      avoidList.hidden = false;
    }
  }

  // ユーザーが手動でリストを切り替える
  toggleListsVisible() {
    this.count++;
    const cannotList = document.getElementById("cannot-list")
    const avoidList = document.getElementById("avoid-list")

    cannotList.hidden = !cannotList.hidden
    avoidList.hidden = !avoidList.hidden
  }
}
