class CreateActionTags < ActiveRecord::Migration[7.2]
  def change
    create_table :action_tags do |t|
      t.string :name, default: "未分類", null: false, index: { unique: true }
      t.timestamps
    end
  end
end
