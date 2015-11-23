class AddRedPackToOrder < ActiveRecord::Migration
  def change
    add_column :red_packs, :order_id, :integer, comment: '红包关联订单'
  end
end
