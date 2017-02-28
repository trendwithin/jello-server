class V2::BaseController < ApplicationController
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    if ENV['AUTHORIZED_USERNAME']
      authenticate_or_request_with_http_digest do |username|
        ENV['AUTHORIZED_PASSWORD'] if ENV['AUTHORIZED_USERNAME'] == username
      end
    end
  end
end
