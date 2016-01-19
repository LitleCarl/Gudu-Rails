class CreateExpresses < ActiveRecord::Migration
  def change
    create_table :expresses do |t|
      t.references :expresser, comment: '快递员'
      t.references :order, comment: '关联订单'
      t.timestamps null: false
    end
  end
end
