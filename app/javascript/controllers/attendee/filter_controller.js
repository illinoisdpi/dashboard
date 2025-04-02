import { Controller } from "@hotwired/stimulus"

//This is used for the attendance#_form.html.erb to filter the students by name
// Connects to data-controller="attendee--filter"
export default class extends Controller {
  static targets = ["filterInput", "filterList"]

  connect() {
    // No need to initialize visibility since we're filtering entries instead of showing/hiding a list
  }

  filter() {
    const filterValue = this.filterInputTarget.value.toLowerCase();
    const entries = this.filterListTarget.querySelectorAll('.student-entry');

    entries.forEach(entry => {
      const studentName = entry.querySelector('.student-name').textContent.toLowerCase();
      entry.style.display = studentName.includes(filterValue) ? 'block' : 'none';
    });
  }

  select(event) {
    const optionElement = event.target.closest('.option');
    if (optionElement) {
      this.filterInputTarget.value = optionElement.textContent.trim();
      this.toggleListVisibility();
      this.filterInputTarget.blur();
    }
  }

  toggleListVisibility() {
    if (this.filterListTarget.style.display === "none") {
      this.filterListTarget.style.display = "block";
      this.overlayTarget.style.display = "block";
    } else {
      this.filterListTarget.style.display = "none";
      this.overlayTarget.style.display = "none";
    }
  }
}
