class Item < ActiveRecord::Base
  belongs_to :list

  validates :title, length: { minimum: 1, maximum: 100 }, presence: true
  validates :list, presence: true
end
