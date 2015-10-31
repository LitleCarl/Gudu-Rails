class AddSignatureToStore < ActiveRecord::Migration
  def change
    add_column :stores, :signature, :text, comment: '店铺签名'
    add_column :stores, :month_sale, :integer, default: 0, comment: '月销量'
    add_column :stores, :back_ratio, :float, default: 0, comment: '回头率,0-1'
    add_column :stores, :main_food_list, :text, comment: '主打商品名称列表'
  end
end
