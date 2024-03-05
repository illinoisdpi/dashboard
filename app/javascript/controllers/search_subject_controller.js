import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-subject"
export default class extends Controller {
  static targets = ["inputField", "optionsList", "hiddenField"]
  static values = { cohort: String }

  connect() {
    console.log("Hello, Stimulus!")
  }

  search() {
    this.optionsListTarget.style.display = "block";
    const inputFieldValue = this.inputFieldTarget.value
    // Append the subject_search parameter as a query string
    const url = `/cohorts/${
      this.cohortValue
    }/enrollments/search?subject_search=${encodeURIComponent(inputFieldValue)}`

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      }
    }).then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }
  

  select(event) {
    this.inputFieldTarget.blur()
    this.toggleListVisibility()
    this.inputFieldTarget.value = event.target.innerText
    this.hiddenFieldTarget.value = event.target.dataset.subjectId
  }

  toggleListVisibility() {
    
    this.optionsListIsNotVisible() ? this.optionsListTarget.style.display = "block" : this.optionsListTarget.style.display = "none"
  
  }

  optionsListIsNotVisible() {
    console.log(!this.optionsListTarget.display === "none")
    return !this.optionsListTarget.display === "none"
  }
}
