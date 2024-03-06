import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-subject"
export default class extends Controller {
  static targets = ["inputField", "optionsList", "hiddenField"]
  static values = { cohort: String }

  
  search() {
    this.optionsListTarget.style.display = "block";
    const inputFieldValue = this.inputFieldTarget.value
    // Append the subject_search parameter as a query string
    const url = `/cohorts/${this.cohortValue}/enrollments/search?subject_search=${encodeURIComponent(inputFieldValue)}`

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      }
    }).then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }
  

  select(event) {
    this.inputFieldTarget.value = event.target.dataset.subjectName
    this.hiddenFieldTarget.value = event.target.dataset.subjectId
    this.toggleListVisibility()
    this.inputFieldTarget.blur()
  }

  toggleListVisibility() { 
    this.optionsListIsNotVisible() ? this.optionsListTarget.style.display = "block" : this.optionsListTarget.style.display = "none"
  }

  hideWhenEmpty() {
    if (this.inputFieldTarget.value === "" && this.inputFieldTarget !== document.activeElement) {
      this.toggleListVisibility()
    }
  }

  optionsListIsNotVisible() {
    return !this.optionsListTarget.display === "none"
  }
}
