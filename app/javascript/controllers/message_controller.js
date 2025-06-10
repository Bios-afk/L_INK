import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  static values = { userId: Number }
  static targets = ["message"]
  connect() {
    // triggered when a new message is added to the page
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    if (this.userIdValue === currentUserId) {
      this.element.classList.add('message-from-me-container');
      this.element.classList.remove('message-from-another-container');
      this.messageTarget.classList.add('message-from-me');
      this.messageTarget.classList.remove('message-from-another');
    } else {
      this.element.classList.add('message-from-another-container');
      this.element.classList.remove('message-from-me-container');
      this.messageTarget.classList.add('message-from-another');
      this.messageTarget.classList.remove('message-from-me');
    }
    this.element.scrollIntoView({ behavior: 'smooth' }); // scroll to the bottom of the page
  }
}
