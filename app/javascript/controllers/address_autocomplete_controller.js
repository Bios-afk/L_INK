// app/javascript/controllers/address_autocomplete_controller.js
import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = { apiKey: String }

  static targets = ["address"]

  connect() {
    console.log("connecté")
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "address",
      limit: 3,
      placeholder: "Entrez votre adresse..."
    })
    this.geocoder.addTo(this.element)

    this.geocoder.on("result", event => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())
  }

  #setInputValue(event) {
  this.addressTarget.value = event.result["place_name"]
  }

  #clearInputValue() {
  this.addressTarget.value = ""
  }

  disconnect() {
    this.geocoder.onRemove()
  }
}
