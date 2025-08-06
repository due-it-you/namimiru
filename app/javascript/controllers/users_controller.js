import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="users"
export default class extends Controller {
  connect() {
  }

  createUser() {
    console.log('try to create the user.')
  }
}
