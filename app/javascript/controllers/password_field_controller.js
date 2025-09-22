import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-field"
export default class extends Controller {
  switchVisible() {
    let passwordField = document.getElementById("user-password");
    if (passwordField.type === "password") {
      passwordField.type = "text" 
    } else {
      passwordField.type = "password" 
    };
  }
}
