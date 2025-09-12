class AddColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    change_table :users do |t|
      t.string :name, null: false
      t.boolean :is_guest, null: false, default: false
    end
  end
end
