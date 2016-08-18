class ListPolicy < ApplicationPolicy

  attr_reader :current_user, :list

  def initialize(current_user, list)
    @current_user = current_user
    @list = list
  end

  def items?
    update?
  end

  # def show?
  #   user.admin? || user==current_user
  # end

  def update?
    create? || list.to_public?
  end
  #
  # def edit?
  #   show?
  # end

  def create?
    current_user.admin? || current_user==list.user
  end

  def destroy?
    create?
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      lists = []
      if user.admin?
        lists = List.all
      else
        lists = List.where(user: user)
      end
      lists
    end

  end

end
