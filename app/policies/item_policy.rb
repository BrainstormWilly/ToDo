class ItemPolicy < ApplicationPolicy

  attr_reader :current_user, :item

  def initialize(current_user, item)
    @current_user = current_user
    @item = item
  end

  def update?
    current_user.admin? || item.list.user==current_user || item.list.to_public?
  end

  def destroy?
    update?
  end

end
