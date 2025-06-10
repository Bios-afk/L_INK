import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions", "selected"]
  static values = {
    selectedCities: { type: Array, default: [] }
  }

  connect() {
    this.apiUrl = "https://countriesnow.space/api/v0.1/countries/population/cities"
    this.citiesList = []
    this.fetchCities()

    // ✅ Réaffichage des villes sélectionnées
    if (this.hasSelectedCitiesValue && Array.isArray(this.selectedCitiesValue)) {
      this.selectedCitiesValue.forEach(city => this.addCityBadge(city))
    }
  }

  fetchCities() {
    fetch(this.apiUrl)
      .then((r) => r.json())
      .then((data) => {
        this.citiesList = data.data.map(c => c.city).filter((v, i, a) => a.indexOf(v) === i)
      })
  }

  search() {
    const query = this.inputTarget.value.toLowerCase()
    if (!query) {
      this.suggestionsTarget.innerHTML = ""
      return
    }

    const matches = this.citiesList.filter(city =>
      city.toLowerCase().startsWith(query)
    ).slice(0, 2)

    this.suggestionsTarget.innerHTML = matches
      .map(city => `<ul data-action="click->city-autocomplete#selectCity">${city}</ul>`)
      .join("")
  }

  selectCity(e) {
    const city = e.target.textContent
    this.addCityBadge(city)
    this.inputTarget.value = ""
    this.suggestionsTarget.innerHTML = ""
  }

  addCityBadge(city) {
    // Empêche les doublons
    const alreadyAdded = [...this.selectedTarget.querySelectorAll("input")]
      .some(input => input.value === city)
    if (alreadyAdded) return

    const badge = document.createElement("span")
    badge.className = "badge bg-primary me-2 mb-2 d-inline-flex align-items-center"

    const label = document.createElement("span")
    label.textContent = city

    const close = document.createElement("span")
    close.innerHTML = " &times;"
    close.classList.add("remove-city")
    close.style.cursor = "pointer"
    close.style.marginLeft = "0.3em"
    close.setAttribute("data-action", "click->city-autocomplete#removeCity")

    const hiddenInput = document.createElement("input")
    hiddenInput.type = "hidden"
    hiddenInput.name = "cities[]"
    hiddenInput.value = city

    badge.appendChild(label)
    badge.appendChild(close)
    badge.appendChild(hiddenInput)
    this.selectedTarget.appendChild(badge)
  }

  removeCity(e) {
    e.target.closest("span.badge").remove()
  }

    reset() {
    this.selectedTarget.innerHTML = "";
    this.inputTarget.value = "";
    this.selectedCitiesValue = [];
  }
}
