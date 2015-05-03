OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 585469691588758, 'fa1c3640e58c49b2253e31ce7cc14801'
end
