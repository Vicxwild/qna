class Question < ApplicationRecord
  has_many :answers, -> { sort_by_best }, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  has_many_attached :files

  validates :title, :body, :author, presence: true
end
