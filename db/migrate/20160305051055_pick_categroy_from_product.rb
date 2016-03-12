class PickCategroyFromProduct < ActiveRecord::Migration
  def change
    add_column :stores, :boost, :integer, null: false, default: 0, comment: '店铺权重'
  end
end
