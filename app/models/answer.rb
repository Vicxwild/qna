class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, :author, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_the_best
    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update(best: true)
    end
  end
end
