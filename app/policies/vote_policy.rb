class VotePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def like?
    user&.present? && !user&.author_of?(record)
  end

  def dislike?
    like?
  end

  def revote?
    record.voted?(user)
  end
end
