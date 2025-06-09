import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    lat: Number,
    lng: Number,
    apiKey: String,
  };

  connect() {
    console.log("conected controller map");
    // Ne pas lancer si l'élément est caché
    if (this.element.offsetParent === null) return;
  }

  loadMap() {
    console.log("load map");
    this.element.innerHTML = "";
    mapboxgl.accessToken = this.apiKeyValue;
    // if (this.map) return
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [this.lngValue, this.latValue],
      zoom: 12,
    });
    console.log(this.element)

    this.#addMarkersToMap();
    // this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    new mapboxgl.Marker()
      .setLngLat([this.lngValue, this.latValue])
      .addTo(this.map);
  }


  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    bounds.extend([this.lngValue, this.latValue]);
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
      }
}
