import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="student-filter"
export default class extends Controller {
  static targets = ["input", "entry"]

  connect() {
    console.log("Student filter controller connected");
  }

  filter() {
    const searchTerm = this.inputTarget.value.toLowerCase();
    
    this.entryTargets.forEach(entry => {
      const studentNameElement = entry.querySelector('.student-name');
      if (!studentNameElement) return;
      
      const studentName = studentNameElement.textContent.toLowerCase();
      if (studentName.includes(searchTerm)) {
        entry.style.display = 'block';
      } else {
        entry.style.display = 'none';
      }
    });
  }
} 