class AddOrderNumberToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :order_number, :string, comment: '订单编号'
  end
end
