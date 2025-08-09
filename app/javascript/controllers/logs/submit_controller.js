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
      const idToken = liff.getIDToken();
    }).catch((err) => {
      console.error("LIFF init failed", err);
    });
  }

  get isDevelopmentEnvironment() {
    return document.head.querySelector("meta[name=rails_env]").content === "development"
  }
} 
