module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def votes_sum
    votes.sum(:value)
  end

  def voted?(user)
    votes.exists?(user_id: user.id)
  end
end
