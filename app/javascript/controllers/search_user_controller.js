import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search-user"
export default class extends Controller {
  static targets = ['inputField', 'optionsList', 'hiddenField', 'overlay'];

  connect() {
    // Event listeners for focus and blur
    this.inputFieldTarget.addEventListener('focus', this.showOptionsList.bind(this));
    this.inputFieldTarget.addEventListener('blur', this.hideOptionsListOnBlur.bind(this));
  }

  disconnect() {
    // Clean up event listeners
    this.inputFieldTarget.removeEventListener('focus', this.showOptionsList.bind(this));
    this.inputFieldTarget.removeEventListener('blur', this.hideOptionsListOnBlur.bind(this));
  }

  search_by_name() {
    if (this.inputFieldTarget.value === '') {
      this.hiddenFieldTarget.value = '';
    }

    const inputFieldValue = this.inputFieldTarget.value;
    const url = `/users/search_by_name?name=${encodeURIComponent(inputFieldValue)}`;

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
          this.showOptionsList();
        })
        .catch((error) => {
          console.error('Fetch error:', error);
          this.optionsListTarget.innerHTML =
            '<div class="option">Search failed. Please try again.</div>';
          this.showOptionsList();
        });
    }, 250);
  }

  select(event) {
    const optionElement = event.target.closest('.option');

    if (optionElement) {
      this.inputFieldTarget.value = optionElement.dataset.userName;
      this.hiddenFieldTarget.value = optionElement.dataset.userId;
      this.hideOptionsList();
      this.inputFieldTarget.blur();
    }
  }

  showOptionsList() {
    this.optionsListTarget.style.display = 'block';
    this.overlayTarget.style.display = 'block';
    this.overlayTarget.style.pointerEvents = 'none'; // Allow clicks through the overlay
  }

  hideOptionsList() {
    this.optionsListTarget.style.display = 'none';
    this.overlayTarget.style.display = 'none';
  }

  hideOptionsListOnBlur() {
    // Delay hiding to allow a click event on an option to register
    setTimeout(() => {
      if (!this.inputFieldTarget.contains(document.activeElement)) {
        this.hideOptionsList();
      }
    }, 150);
  }
}
