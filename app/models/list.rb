class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :title, length: { minimum: 1, maximum: 100 }, presence: true
  validates :user, presence: true
end
