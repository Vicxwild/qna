module LinksList
  extend ActiveSupport::Concern

  included do
    attributes :links_list
  end

  def links_list
    object.links.map { |f| {name: f.name, url: f.url} }
  end
end
