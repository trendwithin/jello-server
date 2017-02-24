module AuthenticationHelpers
  def authorization_headers(options = {})
    username = options.fetch(:username, ENV['AUTHORIZED_USERNAME'])
    password = options.fetch(:password, ENV['AUTHORIZED_PASSWORD'])
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    { 'Authorization' => auth  }
  end
end
