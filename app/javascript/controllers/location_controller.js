import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="location"
export default class extends Controller {
  connect() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;

        fetch("/users/set_location", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ latitude, longitude })
        });
      });
    }
  }
}
