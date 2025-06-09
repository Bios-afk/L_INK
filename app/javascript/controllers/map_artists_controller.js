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
    console.log("Markers:", this.markersValue);;
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
      const mapMarker = new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .addTo(this.map);

      mapMarker.getElement().addEventListener("click", () => {
        const artistId = marker.id; // <-- récupère l'id ici
        console.log("Fetch artist with id:", artistId);

        // Ouvre l'offcanvas Bootstrap
        const offcanvasEl = document.getElementById("artistOffcanvas");
        const bsOffcanvas = new bootstrap.Offcanvas(offcanvasEl);
        bsOffcanvas.show();

        // Charge le contenu dynamique via fetch
        fetch(`/artists/${artistId}/card_details`, {
          headers: { Accept: "text/html" }
        })
        .then(response => response.text())
        .then(html => {
          const content = document.querySelector('#artistOffcanvasBody');
          content.innerHTML = html;

          // 🔁 Redéclenche Stimulus (et d'autres events Turbo/Stimulus)
          document.dispatchEvent(new Event("turbo:load"));
        });
      });
    });
  }

  fitMapToMarkers() {
    if (!this.markersValue.length) return;

    const bounds = new mapboxgl.LngLatBounds();

    this.markersValue.forEach(marker => {
      bounds.extend([marker.lng, marker.lat]);
    });

    this.map.fitBounds(bounds, { padding: 70, maxZoom: 12, duration: 0 });
  }
}
