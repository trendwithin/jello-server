class V1::BoardSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :archived, :links

  belongs_to :creator, serializer: V1::UserSerializer

  def links
    [
      link(:self, v1_board_url(object))
    ]
  end
end
