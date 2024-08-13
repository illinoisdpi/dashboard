# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.recaptcha[:site_key]
  config.secret_key = Rails.application.credentials.recaptcha[:secret_key]
  # Uncomment the following line if you're working in development mode
  # config.skip_verify_env.push("development")
end
