class AddOwnerIdToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :owner_id, :integer, comment: '关联店铺拥有人'
  end
end
