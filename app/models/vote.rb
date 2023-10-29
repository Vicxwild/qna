class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :voteable, :user, presence: true
  validate :author_cant_vote
  validate :user_cant_vote_twice

  private

  def author_cant_vote
    errors.add(:vote, "Author can't vote") if user&.author_of?(voteable)
  end

  def user_cant_vote_twice
    errors.add(:vote, "You can't vote twice") if voteable&.voted?(user)
  end
end
