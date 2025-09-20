class ChangeUsersColumnsNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_default(:users, :name, from: nil, to: nil)
    change_column_default(:users, :email, from: "", to: nil)
    change_column_default(:users, :encrypted_password, from: "", to: nil)

    change_column_null(:users, :name, true)
    change_column_null(:users, :email, true)
    change_column_null(:users, :encrypted_password, true)
  end
end
