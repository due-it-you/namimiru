import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="liff"
export default class extends Controller {
  connect() {
    // ? 開発用 : 本番用 LIFF ID
    const testChannelDevLiffId = "2007822088-DyWMzRPP";
    const namimiruChannelProdLiffId = "2007822090-JdbBVDrp";
    const liffId = this.isDevelopmentEnvironment ? testChannelDevLiffId : namimiruChannelProdLiffId;
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
