class AddCostToSpecification < ActiveRecord::Migration
  def change
    add_column :specifications, :cost, :decimal, default: 0.00, precision: 10, scale: 2, comment: '成本价'
  end
end
