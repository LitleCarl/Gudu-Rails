class AddMonthSaleToProduct < ActiveRecord::Migration
  def change
    add_column :products, :month_sale, :integer, default: 23, comment: '月售'
  end
end
