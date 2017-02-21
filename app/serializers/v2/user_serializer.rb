class V2::UserSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :gravatar_url, :created_at, :updated_at, :links

  has_many :boards, serializer: V2::BoardPreviewSerializer do
    object.boards.where(archived: false)
  end
  has_many :archived_boards, serializer: V2::BoardPreviewSerializer do
    object.boards.where(archived: true)
  end

  def links
    [
      link(:self, v2_user_url(object))
    ]
  end
end
