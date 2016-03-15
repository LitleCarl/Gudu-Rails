class AddSuitIdToOrders < ActiveRecord::Migration
  def change
    add_column :suits, :logo_filename, :string, comment: '套餐图片'
  end
end
