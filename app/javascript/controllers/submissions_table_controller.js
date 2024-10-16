import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    if (!$.fn.DataTable.isDataTable(this.element)) {
      $(this.element).DataTable({
        ordering: true, // Enable sorting (set to true if you want sorting)
        paging: true, // Enable pagination
        autoWidth: false, // Disable automatic column resizing
        columns: [
          { width: '20%' },
          { width: '20%' },
          { width: '20%' },
          { width: '20%' },
        ],
      });
    }
  }
}
