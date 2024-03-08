import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-subject"
export default class extends Controller {
  static targets = ["inputField", "optionsList", "hiddenField", "overlay"]
  static values = { cohort: String }

 
  
  search() {
    const inputFieldValue = this.inputFieldTarget.value
    var url = `/impressions/search?subject_search=${encodeURIComponent(inputFieldValue)}`
    
    if (window.location.pathname.includes('cohort')) {
      url += `&cohort_id=${this.cohortValue}`
    }

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {

      this.optionsListTarget.style.display = "block";
      this.overlayTarget.style.display = "block";
      
      fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      }).then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error, status: ${response.status}`);
        }
        return response.text();
      }).then(html => Turbo.renderStreamMessage(html))
      .catch(error => {
        console.error('Fetch error:', error);
        
        this.optionsListTarget.innerHTML = '<div class="option">Search failed. Please try again.</div>';
      });

    }, 250)
    
  }

  select(event) {
    this.inputFieldTarget.value = event.target.dataset.subjectName
    this.hiddenFieldTarget.value = event.target.dataset.subjectId
    this.toggleListVisibility()
    this.inputFieldTarget.blur()
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

  hideWhenEmpty() {
    this.toggleListVisibility()
  }

  optionsListIsNotVisible() {
    return !this.optionsListTarget.style.display === "none"
  }
}
