class CreateActionTags < ActiveRecord::Migration[7.2]
  def change
    create_table :action_tags do |t|
      t.timestamps
    end
  end
end
