class ActionTag < ApplicationRecord
  has_many :action_items

  belongs_to :user

  validates :name, presence: true, length: { maximum: 8 }

  def to_combobox_display
    name
  end
end
