class CreateSuitSpecifications < ActiveRecord::Migration
  def change
    create_table :suit_specifications do |t|
      t.references :suit, comment:'关联套餐'
      t.references :specification, comment:'关联规格'
      t.timestamps null: false
    end
  end
end
