class V1::BoardPreviewSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :id, :title, :links

  def links
    [
      link(:self, v1_board_url(object))
    ]
  end
end
