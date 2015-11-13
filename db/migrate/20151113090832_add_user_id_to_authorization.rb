class AddUserIdToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :user_id, :integer, comment: '关联用户'
  end
end
