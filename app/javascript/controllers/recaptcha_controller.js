import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.loadRecaptcha();
  }

  loadRecaptcha() {
    const script = document.createElement('script');
    script.src = 'https://www.google.com/recaptcha/api.js';
    script.async = true;
    script.defer = true;
    document.body.appendChild(script);
  }
}
