class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :voteable, :user, presence: true
  validate :author_cant_vote

  private

  def author_cant_vote
    errors.add(:vote, "Author can't vote") if user&.author_of?(voteable)
  end
end
