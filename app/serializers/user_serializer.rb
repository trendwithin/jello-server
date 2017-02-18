class UserSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :gravatar_url, :created_at, :updated_at, :links

  def links
    [
      link(:self, user_url(object)),
      link(:boards, user_boards_url(object))
    ]
  end
end
