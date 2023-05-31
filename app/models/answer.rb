class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: "author_id"

  validates :body, :author, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_the_best
    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update(best: true)
    end
  end
end
