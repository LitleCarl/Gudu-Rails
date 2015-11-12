class AddUnionIdToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :union_id, :string, comment: '用户唯一身份id'
  end
end
