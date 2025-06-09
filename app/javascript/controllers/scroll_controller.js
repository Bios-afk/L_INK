import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-messages"
export default class extends Controller {
  connect() {
    console.log('oui')
    this.element.scrollTop = this.element.scrollHeight
  }
}
