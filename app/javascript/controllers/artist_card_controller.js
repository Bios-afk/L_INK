import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="artist-card"
export default class extends Controller {
  static targets = ["down", "photos", "map"]

  connect() {
    this.showingMap = false
    console.log('controller conected...')
  }

  toggleBack(){
    this.downTarget.classList.add('shrunk')

    setTimeout(() => {
      if(this.showingMap) {
        this.mapTarget.classList.add("hidden")
        this.photosTarget.classList.remove("hidden")
      }else {
        this.photosTarget.classList.add("hidden")
        this.mapTarget.classList.remove("hidden")
      }

      this.downTarget.classList.remove('shrunk')
      this.showingMap = !this.showingMap
    }, 500);
  }
}
