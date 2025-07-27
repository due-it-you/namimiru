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
}
