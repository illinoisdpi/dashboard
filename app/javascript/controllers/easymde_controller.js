import { Controller } from "@hotwired/stimulus"
import * as EasyMDE from "easymde";
export default class extends Controller {
  connect() {
    console.log("EasyMDE controller connected");

    this.initializeEasyMDE()
  }

  initializeEasyMDE() {
    this.element.querySelectorAll('.easymde').forEach((textarea) => {
      if (!textarea.classList.contains('easymde-initialized')) {
        new EasyMDE({ 
          element: textarea,
          autoDownloadFontAwesome: false,
          toolbar: [
            "bold", "italic", "heading", "|", 
            "quote", "unordered-list", "ordered-list", "|", 
            "preview", "side-by-side", "fullscreen", "|", 
            "guide"
          ],
          spellChecker: true
        });
        textarea.classList.add('easymde-initialized');
      }
    });
  }
}
