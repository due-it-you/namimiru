class ActionTag < ApplicationRecord
  has_many :action_items

  belongs_to :user, primary_key: :uuid, foreign_key: :user_uuid

  validates :name, presence: true, length: { maximum: 8, message: "は8文字以内で入力してください。" }

  def to_combobox_display
    name
  end
end
