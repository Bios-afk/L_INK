import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = {
    rating: Number // Initial rating value
  }

  connect() {
    // Apply initial rating if it exists
    this.updateStars(this.hasRatingValue ? this.ratingValue : 0)
    if (this.hasRatingValue) {
      this.inputTarget.value = this.ratingValue
    }
  }

  select(event) {
    const value = parseInt(event.currentTarget.dataset.starRatingValue)
    const currentRating = parseInt(this.inputTarget.value)

    // If the clicked star is the currently selected one, deselect it
    if (currentRating === value) {
      this.inputTarget.value = 0
      this.updateStars(0)
    } else {
      // Otherwise, select the clicked star
      this.inputTarget.value = value
      this.updateStars(value)
    }
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
    reset() {
    this.inputTarget.value = 0;
    this.updateStars(0);
  }
}
