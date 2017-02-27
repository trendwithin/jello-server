class V2::BaseController < ApplicationController
  include Knock::Authenticable

  before_action :authenticate_user

  private

  def unauthorized_entity(entity)
    respond_with_unauthorized
  end
end
