class ChangeEnabledFromToAcceptNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :action_items, :enabled_from, true
  end
end
