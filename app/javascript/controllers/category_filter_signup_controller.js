// app/javascript/controllers/category_filter_signup_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "checkbox", "form"]

  connect() {
    this.categoryOffcanvasEl = document.getElementById("categoryOffcanvas")

    if (!window.bootstrap || !this.categoryOffcanvasEl) {
      console.error("❌ Bootstrap ou Offcanvas introuvable.")
      return
    }

    this.categoryOffcanvas = window.bootstrap.Offcanvas.getOrCreateInstance(this.categoryOffcanvasEl)

    // Cocher les cases déjà sélectionnées au chargement (si tu prévois cette fonctionnalité plus tard)
    this.updateSelectedCategories()
  }

  applyCategories() {
    console.log("✅ applyCategories appelée");
    this.updateSelectedCategories()
    this.categoryOffcanvas.hide()
  }

  updateSelectedCategories() {
    console.log("🛠 updateSelectedCategories appelée");

    this.containerTarget.innerHTML = ""

    // Supprimer les anciens champs hidden
    document.querySelectorAll("input[name='user[category_ids][]']").forEach(input => input.remove())

    this.checkboxTargets.forEach(checkbox => {
      console.log(`🔎 Checkbox ${checkbox.id} checked ?`, checkbox.checked);
      if (checkbox.checked) {
        // Affichage visuel des catégories sélectionnées
        const badge = document.createElement("span")
        badge.className = "badge bg-primary me-2 mb-2"
        badge.textContent = checkbox.nextElementSibling.textContent

        // Bouton pour retirer une catégorie
        const close = document.createElement("span")
        close.innerHTML = " &times;"
        close.style.cursor = "pointer"
        close.style.marginLeft = "0.3em"
        close.addEventListener("click", () => {
          checkbox.checked = false
          this.updateSelectedCategories()
        })

        badge.appendChild(close)
        this.containerTarget.appendChild(badge)

        // Ajout d’un champ hidden pour envoyer la donnée au backend
        const hiddenInput = document.createElement("input")
        hiddenInput.type = "hidden"
        hiddenInput.name = "user[category_ids][]"
        hiddenInput.value = checkbox.value
        this.formTarget.appendChild(hiddenInput)

        console.log("✅ Champ hidden ajouté :", hiddenInput);


      }
    })
  }
}
