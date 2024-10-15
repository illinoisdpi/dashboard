import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    const table = $(this.element).find('#submissionsTable').DataTable({
      ordering: true, // Enable sorting
    });
  }
}
