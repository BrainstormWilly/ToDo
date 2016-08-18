class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  before_save { self.permissions ||= :to_public }

  validates :title, length: { minimum: 1, maximum: 100 }, presence: true
  validates :user, presence: true

  enum permissions: [:to_public, :to_private]
end
