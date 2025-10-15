class ActionTag < ApplicationRecord
  has_many :action_items

  validates :name, presence: true, length: { maximum: 8 }, uniqueness: true
end
