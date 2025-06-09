import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="artist-card"
export default class extends Controller {
  static targets = ["down", "photos", "map", "cardIcon"]
  static values = {
    lat: Number,
    lng: Number,
  }

  connect() {
    this.showingMap = false
    console.log('controller conected...')
  }

  toggleBack(event){
    event.stopPropagation();
    this.downTarget.classList.add('shrunk')

    setTimeout(() => {
      if(this.showingMap) {
        this.mapTarget.classList.add("hidden")
        this.photosTarget.classList.remove("hidden")
      }else {
        this.photosTarget.classList.add("hidden")
        this.mapTarget.classList.remove("hidden")

        // affiche ma map si elle est affiché
        const mapController = this.application.getControllerForElementAndIdentifier(this.mapTarget, "map")
        console.log(mapController)
        if (mapController && typeof mapController.loadMap === "function") {
          mapController.loadMap()
        } else {
          console.warn('mapController non trouvé ou méthode absente')
        }
        // console.log(this.latValue)
        // this.element.dispatchEvent(
        //   new CustomEvent("map:focus", {
        //     bubbles: true, // super important : remonte dans le DOM jusqu'à MapController
        //     detail: {
        //       lat: this.latValue,
        //       lng: this.lngValue
        //     }
        //   })
        // )
      }

      this.downTarget.classList.remove('shrunk')
      this.showingMap = !this.showingMap
      if (this.hasCardIconTarget) {
        // Animation de sortie
        this.cardIconTarget.classList.remove("card-icon-show")
        this.cardIconTarget.classList.add("card-icon-hide")

        // Changement d'icône après transition (200ms)
        setTimeout(() => {
          if (this.showingMap) {
            this.cardIconTarget.classList.remove("fa-map-location-dot")
            this.cardIconTarget.classList.add("fa-image")
          } else {
            this.cardIconTarget.classList.remove("fa-image")
            this.cardIconTarget.classList.add("fa-map-location-dot")
          }

          // Animation d'entrée
          this.cardIconTarget.classList.remove("card-icon-hide")
          this.cardIconTarget.classList.add("card-icon-show")
        }, 200)
      }

    }, 500);
  }
}
