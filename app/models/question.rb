class Question < ApplicationRecord
  has_many :answers, -> { sort_by_best }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, :author, presence: true
end
