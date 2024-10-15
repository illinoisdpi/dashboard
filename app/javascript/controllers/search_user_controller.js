import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search-user"
export default class extends Controller {
  static targets = ['inputField', 'optionsList', 'hiddenField', 'overlay'];

  search() {
    // Clear hiddenField when input is empty to trigger validation if blank form is submitted
    if (this.inputFieldTarget.value === '') {
      this.hiddenFieldTarget.value = '';
    }

    const inputFieldValue = this.inputFieldTarget.value;
    const url = `/users/search?name=${encodeURIComponent(inputFieldValue)}`;

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
          this.toggleListVisibility();
          this.optionsListTarget.style.display = 'block';
          this.overlayTarget.style.display = 'block';
        })
        .catch((error) => {
          console.error('Fetch error:', error);
          this.optionsListTarget.innerHTML =
            '<div class="option">Search failed. Please try again.</div>';
          this.optionsListTarget.style.display = 'block';
          this.overlayTarget.style.display = 'block';
        });
    }, 250);
  }

  select(event) {
    const optionElement = event.target.closest('.option');

    if (optionElement) {
      this.inputFieldTarget.value = optionElement.dataset.userName;
      this.hiddenFieldTarget.value = optionElement.dataset.userId;
      this.inputFieldTarget.blur();
    }
  }

  toggleListVisibility() {
    if (this.optionsListIsNotVisible()) {
      this.optionsListTarget.style.display = 'block';
      this.overlayTarget.style.display = 'block';
    } else {
      this.optionsListTarget.style.display = 'none';
      this.overlayTarget.style.display = 'none';
    }
  }

  optionsListIsNotVisible() {
    return this.optionsListTarget.style.display === 'none';
  }
}
