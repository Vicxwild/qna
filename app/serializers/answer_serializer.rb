class AnswerSerializer < ActiveModel::Serializer
  include LinksList
  include FilesList

  attributes :id, :body, :created_at, :updated_at

  belongs_to :author, serializer: UserSerializer
  has_many :comments, each_serializer: CommentSerializer
end
