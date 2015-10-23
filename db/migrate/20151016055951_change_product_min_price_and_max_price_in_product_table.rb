class ChangeProductMinPriceAndMaxPriceInProductTable < ActiveRecord::Migration
  def change
    change_column :products, :min_price, :string, null: true, default: '0.0'
    change_column :products, :max_price, :string, null: true, default: '0.0'
    change_column :products, :brief, :string, null: true, default: '暂无简介'
  end

end
