module FilesList
  extend ActiveSupport::Concern

  included do
    attributes :files_list
  end

  def files_list
    object.files.map { |f| {name: f.name, url: f.url} }
  end
end
