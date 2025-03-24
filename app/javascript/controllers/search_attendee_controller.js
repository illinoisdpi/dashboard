import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-attendee"
export default class extends Controller {
  static targets = ["inputField", "optionsList", "firstNameField", "lastNameField", "overlay"]
  static values = { cohort: String }

  connect() {
    // Initialize the input field if first/last name fields have values
    if (this.hasFirstNameFieldTarget && this.hasLastNameFieldTarget) {
      const firstName = this.firstNameFieldTarget.value || "";
      const lastName = this.lastNameFieldTarget.value || "";
      if (firstName || lastName) {
        this.inputFieldTarget.value = `${firstName} ${lastName}`.trim();
      }
    }
  }

  search() {
    // Clear fields when input is empty
    if (this.inputFieldTarget.value === "") {
      if (this.hasFirstNameFieldTarget) this.firstNameFieldTarget.value = "";
      if (this.hasLastNameFieldTarget) this.lastNameFieldTarget.value = "";
      this.optionsListTarget.style.display = "none";
      this.overlayTarget.style.display = "none";
      return;
    }
    
    const inputFieldValue = this.inputFieldTarget.value;
    const url = `/cohorts/${this.cohortValue}/attendances/search_attendee?name=${encodeURIComponent(inputFieldValue)}`;

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.optionsListTarget.innerHTML = '<div class="p-2">Searching...</div>';
      this.optionsListTarget.style.display = "block";
      
      fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      }).then(response => {
        if (!response.ok) {
          throw new Error(`Server error: ${response.status} - ${response.statusText}`);
        }
        return response.text();
      }).then(html => {
        try {
          Turbo.renderStreamMessage(html);
          this.optionsListTarget.style.display = "block";
          this.overlayTarget.style.display = "block";
        } catch (error) {
          console.error('Error rendering Turbo Stream:', error);
          this.optionsListTarget.innerHTML = '<div class="p-2">Error rendering results. Please try again.</div>';
        }
      })
      .catch(error => {
        console.error('Fetch error:', error);
        this.optionsListTarget.innerHTML = `<div class="p-2">Search failed: ${error.message}</div>`;
        this.optionsListTarget.style.display = "block";
        this.overlayTarget.style.display = "block";
      });
    }, 250);
  }

  select(event) {
    const optionElement = event.target.closest('.option');

    if (optionElement) {
      // Set the input field to the selected name
      this.inputFieldTarget.value = optionElement.dataset.studentName;
      
      // Set the first and last name fields
      if (this.hasFirstNameFieldTarget) {
        this.firstNameFieldTarget.value = optionElement.dataset.firstName;
      }
      
      if (this.hasLastNameFieldTarget) {
        this.lastNameFieldTarget.value = optionElement.dataset.lastName;
      }
      
      this.toggleListVisibility();
      this.inputFieldTarget.blur();
    }
  }

  toggleListVisibility() {
    if (this.optionsListTarget.style.display === "none") {
      this.optionsListTarget.style.display = "block";
      this.overlayTarget.style.display = "block";
    } else {
      this.optionsListTarget.style.display = "none";
      this.overlayTarget.style.display = "none";
    }
  }
} 