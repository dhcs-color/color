OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_APP_ID, FACEBOOK_SECRET
  :scope => %(user_friends), 
  :client_options => {:ssl => {:ca_file => "/etc/ssl/certs"}
end
