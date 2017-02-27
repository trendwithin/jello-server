class V2::BaseController < ApplicationController
  include Knock::Authenticable

  before_action :authenticate_user
end
