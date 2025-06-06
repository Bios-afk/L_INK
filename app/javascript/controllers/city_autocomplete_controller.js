import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions", "selected"]

  connect() {
    this.apiUrl = "https://countriesnow.space/api/v0.1/countries/population/cities"
    this.citiesList = []
    this.fetchCities()
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

    // empêche les doublons
    const alreadyAdded = [...this.selectedTarget.querySelectorAll("input")]
      .some(input => input.value === city)
    if (alreadyAdded) return

    const badge = document.createElement("span")
    badge.className = "badge bg-primary me-2 mb-2 d-inline-flex align-items-center"

    // texte
    const label = document.createElement("span")
    label.textContent = city

    // bouton de suppression
    const close = document.createElement("span")
    close.innerHTML = " &times;"
    close.classList.add("remove-city")
    close.style.cursor = "pointer"
    close.style.marginLeft = "0.3em"
    close.setAttribute("data-action", "click->city-autocomplete#removeCity")

    // champ caché
    const hiddenInput = document.createElement("input")
    hiddenInput.type = "hidden"
    hiddenInput.name = "cities[]"
    hiddenInput.value = city

    badge.appendChild(label)
    badge.appendChild(close)
    badge.appendChild(hiddenInput)
    this.selectedTarget.appendChild(badge)

    this.inputTarget.value = ""
    this.suggestionsTarget.innerHTML = ""
  }

  removeCity(e) {
    e.target.closest("span.badge").remove()
  }
}
