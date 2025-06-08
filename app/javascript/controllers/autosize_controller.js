import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosize-input-message"
export default class extends Controller {
  connect() {
    console.log('controller resize ok')
    this.resize()
    this.element.addEventListener("input", () => this.resize())
  }

  resize() {
    this.element.style.height = "auto"
    this.element.style.height = this.element.scrollHeight + "px"
  }
}
