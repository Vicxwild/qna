class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user&.author_of?(record) || user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def best?
    user&.author_of?(record.question) || user&.admin?
  end
end
