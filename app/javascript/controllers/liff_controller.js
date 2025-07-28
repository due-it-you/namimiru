import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="liff"
export default class extends Controller {
  connect() {
    liff.init({
      liffId: ENV["LIFF_ID"],
    })
    .then(() => {
        console.log("LIFF initialized");
      })
    .catch(() => {
        console.error("LIFF init failed", err);
      })
  }

  get isDevelopmentEnvironment() {
    return document.head.querySelector("meta[name=rails_env]").content === "development"
  }
}
