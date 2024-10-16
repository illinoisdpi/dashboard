document.addEventListener("turbo:load", function() {
  document.querySelectorAll('.easymde').forEach(function(textarea) {
    new EasyMDE({ 
      element: textarea,
      autoDownloadFontAwesome: false,
      toolbar: [
        "bold", "italic", "heading", "|", 
        "quote", "unordered-list", "ordered-list", "|", 
        "link", "image", "|", 
        "preview", "side-by-side", "fullscreen", "|", 
        "guide"
      ],
      spellChecker: false
    });
  });
});
