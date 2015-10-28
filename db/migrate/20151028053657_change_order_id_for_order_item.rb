class ChangeOrderIdForOrderItem < ActiveRecord::Migration
  def change
    rename_column :order_items, :orders_id, :order_id
  end
end
