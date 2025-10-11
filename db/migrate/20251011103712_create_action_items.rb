class CreateActionItems < ActiveRecord::Migration[7.2]
  def change
    create_table :action_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :enabled_from, null: false
      t.timestamps
    end
  end
end
