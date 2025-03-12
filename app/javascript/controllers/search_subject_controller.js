import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-subject"
export default class extends Controller {
  static targets = ["inputField", "optionsList", "hiddenField", "overlay"]
  static values = { cohort: String }

  search() {
    
    // clear hiddenField when input is empty to trigger validation if blank form is submitted
    if (this.inputFieldTarget.value === "") {
      this.hiddenFieldTarget.value = ""
    }

    const urlSearchParams = new URLSearchParams(window.location.search);
    const cohortId = urlSearchParams.get("cohort_id");

    const queryStringObject = {
      subject_search: this.inputFieldTarget.value,
    };

    if (cohortId !== null) {
      queryStringObject.cohort_id = cohortId;
    }
    const queryString = new URLSearchParams(queryStringObject).toString();
    const url = `/impressions/search?${queryString}`

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      
      fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      }).then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error, status: ${response.status}`);
        }
        return response.text();
      }).then(html => {
        Turbo.renderStreamMessage(html)
        this.optionsListTarget.style.display = "block";
        this.overlayTarget.style.display = "block";
      })
      .catch(error => {
        console.error('Fetch error:', error);
        this.optionsListTarget.innerHTML = '<div class="option">Search failed. Please try again.</div>';
        this.optionsListTarget.style.display = "block";
        this.overlayTarget.style.display = "block";
      });

    }, 250)
    
  }

  select(event) {
    // ensure the click is registered on the option element,
    // even if user clicks on the icon inside the option
    const optionElement = event.target.closest('.option');

    if (optionElement) {
      this.inputFieldTarget.value = optionElement.dataset.subjectName;
      this.hiddenFieldTarget.value = optionElement.dataset.subjectId;
      this.toggleListVisibility();
      this.inputFieldTarget.blur();
    }
  }

  toggleListVisibility() { 
    if (this.optionsListIsNotVisible()) {
      this.optionsListTarget.style.display = "block"
      this.overlayTarget.style.display = "block" 
    } else {
      this.optionsListTarget.style.display = "none"
      this.overlayTarget.style.display = "none"
    }
  }

  optionsListIsNotVisible() {
    return !this.optionsListTarget.style.display === "none"
  }
}
