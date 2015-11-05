class AddStockPerDayToSpecification < ActiveRecord::Migration
  def change
    add_column :specifications, :stock_per_day, :integer, default: 10, null: false, comment: '订单每日更新的库存'
  end
end
