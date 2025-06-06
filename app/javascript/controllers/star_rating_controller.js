import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.updateStars(0)
  }

  select(event) {
    const value = parseInt(event.currentTarget.dataset.starRatingValue)
    this.inputTarget.value = value
    this.updateStars(value)
  }

  updateStars(value) {
    this.stars.forEach(star => {
      const starValue = parseInt(star.dataset.starRatingValue)
      star.classList.toggle("fa-solid", starValue <= value)
      star.classList.toggle("fa-regular", starValue > value)
      star.classList.toggle("text-warning", starValue <= value)
    })
  }

  get stars() {
    return this.element.querySelectorAll(".star")
  }
}
