class V2::BoardSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :archived, :links

  belongs_to :creator, serializer: V2::UserSerializer

  def links
    [
      link(:self, v2_board_url(object))
    ]
  end
end
