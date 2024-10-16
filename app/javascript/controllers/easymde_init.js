document.addEventListener("turbo:load", function() {
  document.querySelectorAll('.easymde').forEach(function(textarea) {
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
});