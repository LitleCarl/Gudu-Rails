class AddPrintCountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :print_count, :integer, comment: '小票打印次数'
  end
end
