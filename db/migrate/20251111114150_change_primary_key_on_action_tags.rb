class ChangePrimaryKeyOnActionTags < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :action_items, :action_tags 

    execute 'ALTER TABLE action_tags DROP CONSTRAINT action_tags_pkey;'
    execute 'ALTER TABLE action_tags ADD PRIMARY KEY (uuid);'

    add_foreign_key :action_items, :action_tags, column: :action_tag_uuid, primary_key: :uuid
  end
end
