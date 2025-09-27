class AddInviteeRoleToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :invitee_role, :string
  end
end
