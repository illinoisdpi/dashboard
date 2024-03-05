import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-subject"
export default class extends Controller {
  static targets = ["inputField"]
  static values = { cohort: String }

  connect() {
    console.log("Hello, Stimulus!")
  }

  test() {
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

  select() {
    console.log("selected!")
  }
}
