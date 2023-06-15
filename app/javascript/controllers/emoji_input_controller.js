import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textInput"];

  addEmoji(event) {
    const emoji = event.target.dataset.emoji;
    this.textInputTarget.value = emoji;
  }
}
