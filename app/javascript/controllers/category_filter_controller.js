import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "checkbox"];
  static values = {
    selectedCategories: Array,
  };

  connect() {
  // Vérifier que bootstrap est accessible
  if (!window.bootstrap) {
    console.error("Bootstrap non trouvé !");
    return;
  }

  this.categoryOffcanvasEl = document.getElementById("categoryOffcanvas");
  this.filtersOffcanvasEl = document.getElementById("filtersOffcanvas");

  this.categoryOffcanvas = window.bootstrap.Offcanvas.getOrCreateInstance(this.categoryOffcanvasEl);
  this.filtersOffcanvas = window.bootstrap.Offcanvas.getOrCreateInstance(this.filtersOffcanvasEl);

  this.mainForm = this.filtersOffcanvasEl.querySelector("form");

  // Ensure selectedCategoriesValue is an array
  if (!this.hasSelectedCategoriesValue || !Array.isArray(this.selectedCategoriesValue)) {
    this.selectedCategoriesValue = [];
  }

  if (this.selectedCategoriesValue.length > 0) {
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = this.selectedCategoriesValue.includes(checkbox.value);
    });
    this.updateSelectedCategories();
  }

  this.categoryOffcanvasEl.addEventListener('show.bs.offcanvas', () => {
    const selectedValues = Array.from(this.mainForm.querySelectorAll("input[name='category_ids[]']")).map(input => input.value);

    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = selectedValues.includes(checkbox.value);
    });
  });

  this.checkboxTargets.forEach(checkbox => {
    checkbox.addEventListener("change", () => this.updateSelectedCategories());
  });
}


  applyCategories() {
    this.updateSelectedCategories();
    this.categoryOffcanvas.hide();

    this.categoryOffcanvasEl.addEventListener('hidden.bs.offcanvas', () => {
      this.filtersOffcanvas.show();
    }, { once: true });
  }

  updateSelectedCategories() {
    this.containerTarget.innerHTML = "";

    this.mainForm.querySelectorAll("input[name='category_ids[]']").forEach(input => input.remove());

    this.checkboxTargets.forEach(checkbox => {
      if (checkbox.checked) {
        const badge = document.createElement("span");
        badge.className = "badge bg-primary me-2 mb-2";
        badge.textContent = checkbox.nextElementSibling.textContent;

        const close = document.createElement("span");
        close.innerHTML = " &times;";
        close.style.cursor = "pointer";
        close.style.marginLeft = "0.3em";
        close.addEventListener("click", () => {
          checkbox.checked = false;
          this.updateSelectedCategories();
        });

        badge.appendChild(close);
        this.containerTarget.appendChild(badge);

        const hiddenInput = document.createElement("input");
        hiddenInput.type = "hidden";
        hiddenInput.name = "category_ids[]";
        hiddenInput.value = checkbox.value;
        this.mainForm.appendChild(hiddenInput);

      }
    });
  }
}
