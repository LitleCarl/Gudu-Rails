class AddChargeJsonToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :charge_json, :text, comment: '订单关联charge'
  end
end
