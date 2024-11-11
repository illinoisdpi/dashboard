import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search-user"
export default class extends Controller {
  static targets = ['inputField', 'optionsList', 'hiddenField', 'overlay'];

  connect() {
    // Bind click event to the document when the controller is connected
    document.addEventListener('click', this.handleClickOutside.bind(this));
  }

  disconnect() {
    // Remove the event listener when the controller is disconnected
    document.removeEventListener('click', this.handleClickOutside.bind(this));
  }

  search_by_name() {
    // Clear hiddenField when input is empty to trigger validation if blank form is submitted
    if (this.inputFieldTarget.value === '') {
      this.hiddenFieldTarget.value = '';
    }

    const inputFieldValue = this.inputFieldTarget.value;
    const url = `/users/search_by_name?name=${encodeURIComponent(
      inputFieldValue
    )}`;

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      fetch(url, {
        headers: {
          Accept: 'text/vnd.turbo-stream.html',
        },
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP error, status: ${response.status}`);
          }
          return response.text();
        })
        .then((html) => {
          Turbo.renderStreamMessage(html);
          this.toggleListVisibility(true); // Show the options list
        })
        .catch((error) => {
          console.error('Fetch error:', error);
          this.optionsListTarget.innerHTML =
            '<div class="option">Search failed. Please try again.</div>';
          this.toggleListVisibility(true);
        });
    }, 250);
  }

  select(event) {
    const optionElement = event.target.closest('.option');

    if (optionElement) {
      this.inputFieldTarget.value = optionElement.dataset.userName;
      this.hiddenFieldTarget.value = optionElement.dataset.userId;
      this.toggleListVisibility(false);
      this.inputFieldTarget.blur();
    }
  }

  toggleListVisibility(show = true) {
    if (show) {
      this.optionsListTarget.style.display = 'block';
      this.overlayTarget.style.display = 'block';
      this.overlayTarget.style.pointerEvents = 'none'; // Allow clicks through the overlay
    } else {
      this.optionsListTarget.style.display = 'none';
      this.overlayTarget.style.display = 'none';
    }
  }

  optionsListIsNotVisible() {
    return this.optionsListTarget.style.display === 'none';
  }

  handleClickOutside(event) {
    // Check if the click target is outside the input field, options list, and overlay
    const isClickInside =
      this.inputFieldTarget.contains(event.target) ||
      this.optionsListTarget.contains(event.target) ||
      this.overlayTarget.contains(event.target);

    if (!isClickInside) {
      // If click is outside, hide the dropdown and overlay
      this.toggleListVisibility(false);
    }
  }
}
