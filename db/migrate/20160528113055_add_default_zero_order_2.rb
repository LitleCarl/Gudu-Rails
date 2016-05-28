class AddDefaultZeroOrder2 < ActiveRecord::Migration
  def change
    change_column :orders, :print_count, :integer, null: false, default: 0
  end
end
