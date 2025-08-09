import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="logs--submit"
export default class extends Controller {
  static targets = ["mood_score"]

  connect() {
  }

  submitMoodScore() {
    const moodScore = this.mood_scoreTarget.value
    // ? 開発用 : 本番用 LIFF ID
    const liffId = this.isDevelopmentEnvironment ? "2007859619-29wykPby" : "2007822090-JdbBVDrp";
    liff.init({ liffId }).then(() => {
      console.log("LIFF initialized");
      const csrfToken = document.querySelector("[name='csrf-token']").content;
      fetch("/logs", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ log: { id_token: liff.getIDToken(), mood_score: moodScore } })
      })
        .then(response => {
          return response.json();
          // もしUIDがDBにない場合に役割作成画面へTurbo.visitで遷移する処理
          // もしUIDがDBにある場合、処理を何もしない
        })
        .then(data => {
          if (data.status === "ok") {

          } else {
          }
        })
        .catch(error => {
          // エラー処理
        })
    })
      .catch((err) => {
        console.error("LIFF init failed", err);
      })
  }

  get isDevelopmentEnvironment() {
    return document.head.querySelector("meta[name=rails_env]").content === "development"
  }
} 
