class ListSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :permissions
end
