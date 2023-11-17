class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def show?
    true
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
    user&.author_of?(record) || user&.admin?
  end
end
