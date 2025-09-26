class AddInvitationColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :invitation_token, :string
    add_column :users, :invitation_created_at, :datetime
  end
end
