import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions", "selected"]

  connect() {
    this.apiUrl = "https://countriesnow.space/api/v0.1/countries/population/cities" // ou une liste locale
    this.citiesList = []
    this.fetchCities()
  }

  fetchCities() {
    fetch("https://countriesnow.space/api/v0.1/countries/population/cities")
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
    ).slice(0, 5)

    this.suggestionsTarget.innerHTML = matches
      .map(city => `<li data-action="click->city-autocomplete#selectCity">${city}</li>`)
      .join("")
  }

  selectCity(e) {
    const city = e.target.textContent

    // empêche les doublons
    const alreadyAdded = [...this.selectedTarget.querySelectorAll("input")]
      .some(input => input.value === city)
    if (alreadyAdded) return

    const badge = document.createElement("span")
    badge.classList.add("badge")
    badge.innerHTML = `
      ${city}
      <input type="hidden" name="cities[]" value="${city}">
      <button type="button" class="remove-city" data-action="click->city-autocomplete#removeCity">x</button>
    `
    this.selectedTarget.appendChild(badge)
    this.inputTarget.value = ""
    this.suggestionsTarget.innerHTML = ""
  }

  removeCity(e) {
    e.target.closest("span.badge").remove()
  }
}
