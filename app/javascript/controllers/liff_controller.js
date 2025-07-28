import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="liff"
export default class extends Controller {
  connect() {
    // ? 開発用 : 本番用 LIFF ID
    const liffId = this.isDevelopmentEnvironment ? "2007822088-DyWMzRPP" : "2007822090-JdbBVDrp";;
    liff.init({
      liffId: liffId,
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
