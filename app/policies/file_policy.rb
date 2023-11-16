class FilePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def destroy?
    user&.author_of?(record) || user&.admin?
  end
end
