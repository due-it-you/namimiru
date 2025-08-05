import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="liff"
export default class extends Controller {
  initialize() {
    // ? 開発用 : 本番用 LIFF ID
    const testChannelDevLiffId = "2007859619-29wykPby";
    const namimiruChannelProdLiffId = "2007822090-JdbBVDrp";
    const liffId = this.isDevelopmentEnvironment ? testChannelDevLiffId : namimiruChannelProdLiffId;
    liff.init({
      liffId: liffId,
    })
      .then(() => {
        console.log("LIFF initialized");
        const csrfToken = document.querySelector("[name='csrf-token']").content;
        fetch("/uid_sessions", {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify({ id_token: liff.getIDToken() })
        })
          .then(response => {
            return response.json();
            // もしUIDがDBにない場合に役割作成画面へTurbo.visitで遷移する処理
            // もしUIDがDBにある場合、処理を何もしない
          })
          .then(data => {
            if (data.status === "ok") {

            } else {
              Turbo.visit('/users/new');
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
