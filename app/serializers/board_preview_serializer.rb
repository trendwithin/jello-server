class BoardPreviewSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :id, :title, :links

  def links
    [
      link(:self, board_url(object))
    ]
  end
end
