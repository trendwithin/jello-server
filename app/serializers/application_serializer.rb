class ApplicationSerializer < ActiveModel::Serializer
  private

  def link(rel, href)
    { rel: rel, href: href }
  end
end
