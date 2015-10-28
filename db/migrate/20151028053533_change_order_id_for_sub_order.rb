class ChangeOrderIdForSubOrder < ActiveRecord::Migration
  def change
    rename_column :sub_orders, :orders_id, :order_id
  end
end
