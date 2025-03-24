import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="name-splitter"
export default class extends Controller {
  static targets = ["fullName", "firstName", "lastName"]

  connect() {
    // Initialize full name field from first and last name fields
    this.updateFullNameFromFields();
  }

  updateFullNameFromFields() {
    if (this.hasFirstNameTarget && this.hasLastNameTarget) {
      const firstName = this.firstNameTarget.value || "";
      const lastName = this.lastNameTarget.value || "";
      
      if (firstName || lastName) {
        this.fullNameTarget.value = `${firstName} ${lastName}`.trim();
      }
    }
  }

  splitName() {
    const fullName = this.fullNameTarget.value.trim();
    if (!fullName) {
      this.firstNameTarget.value = "";
      this.lastNameTarget.value = "";
      return;
    }

    const nameParts = fullName.split(/\s+/);
    
    if (nameParts.length > 0) {
      // First part is first name
      this.firstNameTarget.value = nameParts[0];
      
      // Rest is last name (if any)
      if (nameParts.length > 1) {
        this.lastNameTarget.value = nameParts.slice(1).join(' ');
      } else {
        this.lastNameTarget.value = ''; // Clear last name if only first name provided
      }
    }
  }
} 