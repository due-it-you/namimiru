class ChangePrimaryKeyOnActionItems < ActiveRecord::Migration[7.2]
  def change
    execute 'ALTER TABLE action_items DROP CONSTRAINT action_items_pkey;'
    execute 'ALTER TABLE action_items ADD PRIMARY KEY (uuid);' 
  end
end
