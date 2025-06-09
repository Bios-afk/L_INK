import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String,
    lat: Number,
    lng: Number,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v11",
      center: [this.lngValue, this.latValue],
      zoom: 12
    })

    this.markersValue.forEach(({ lat, lng, pseudo }) => {
  new mapboxgl.Marker()
    .setLngLat([lng, lat])
    .setPopup(new mapboxgl.Popup().setText(pseudo))
    .addTo(this.map)
    })
  }
}
