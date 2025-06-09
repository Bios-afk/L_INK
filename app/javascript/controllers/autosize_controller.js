import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="autosize-input-message"
export default class extends Controller {
  connect() {
    this.resize();
    this.element.addEventListener("input", () => this.resize());
  }

  resize() {
    this.element.style.height = "auto";
    this.element.style.height = this.element.scrollHeight + "px";

    // const messagesContainer = document.getElementById("messages");
    // const chatWrapper = document.querySelector(".chat-wrapper");
    // const formContainer = document.getElementById("message-form");

    // if (messagesContainer && chatWrapper && formContainer) {
    //   const wrapperHeight = chatWrapper.clientHeight + 40;
    //   const formHeight = formContainer.offsetHeight;
    //   messagesContainer.style.height = `${wrapperHeight - formHeight}px`;
    // }
  }
}
