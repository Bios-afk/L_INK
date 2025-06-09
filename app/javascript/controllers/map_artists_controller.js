import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

// Connects to data-controller="map-artists"
export default class extends Controller {
  static values = {
    apiKey: String,
    lat: Number,
    lng: Number,
    markers: Array
  };

  connect() {
    console.log("Lat:", this.latValue, "Lng:", this.lngValue);
    if (this.element.offsetParent === null) return;
    this.loadMap();
  }

  loadMap() {
    this.element.innerHTML = "";

    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [this.lngValue, this.latValue],
      zoom: 12,
    });

    this.addMarkers();
    this.fitMapToMarkers();
  }

  addMarkers() {
    this.markersValue.forEach(marker => {
      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .setPopup(new mapboxgl.Popup().setText(marker.pseudo))
        .addTo(this.map);
    });
  }

  fitMapToMarkers() {
    if (!this.markersValue.length) return;

    const bounds = new mapboxgl.LngLatBounds();

    this.markersValue.forEach(marker => {
      bounds.extend([marker.lng, marker.lat]);
    });

    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  }
}
