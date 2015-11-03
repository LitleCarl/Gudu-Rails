class AddOwnerIdToStore < ActiveRecord::Migration
  def change
    add_column :stores, :owner_id, :integer, comment: '关联商铺拥有人'
  end
end
