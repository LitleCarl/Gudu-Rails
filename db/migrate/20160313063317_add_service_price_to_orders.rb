class AddServicePriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :service_price, :decimal, default: 0.00, precision: 10, scale: 2, comment: '服务费用'
  end
end
