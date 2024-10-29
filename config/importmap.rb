# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "trix", to: "https://unpkg.com/trix@latest/dist/trix.umd.min.js"
pin "@rails/actiontext", to: "https://cdn.jsdelivr.net/npm/@rails/actiontext@6.1.4.4/dist/actiontext.js"
pin "easymde", to: "https://unpkg.com/easymde/dist/easymde.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
