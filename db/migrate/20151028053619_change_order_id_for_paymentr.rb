class ChangeOrderIdForPaymentr < ActiveRecord::Migration
  def change
    rename_column :payments, :orders_id, :order_id
  end
end
