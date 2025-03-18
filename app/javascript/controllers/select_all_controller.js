import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectAll", "checkbox"];

  connect() {
    this.updateSelectAll();
  }

  // When the "Select All" checkbox is toggled, update all child checkboxes
  toggleAll() {
    const checked = this.selectAllTarget.checked;
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = checked;
    });
  }

  // When any individual checkbox is changed, update the state of the "Select All" checkbox
  toggleCheckbox() {
    this.updateSelectAll();
  }

  updateSelectAll() {
    if (this.checkboxTargets.length > 0) {
      const allChecked = this.checkboxTargets.every(checkbox => checkbox.checked);
      this.selectAllTarget.checked = allChecked;
    }
  }
}
