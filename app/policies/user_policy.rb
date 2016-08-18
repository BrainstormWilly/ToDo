class UserPolicy < ApplicationPolicy

  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  # def show?
  #   user.admin? || user==current_user
  # end

  # def update?
  #   show?
  # end
  #
  # def edit?
  #   show?
  # end

  def create?
    current_user.admin?
  end

  def destroy?
    current_user.admin? || current_user==user
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

  end

end
