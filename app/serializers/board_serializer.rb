class BoardSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :archived, :links

  belongs_to :creator, serializer: UserSerializer

  def links
    [
      link(:self, board_url(object))
    ]
  end
end
