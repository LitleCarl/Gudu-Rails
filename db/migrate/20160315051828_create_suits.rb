class CreateSuits < ActiveRecord::Migration
  def change
    create_table :suits do |t|
      t.references :campus, comment: '关联学校'
      t.decimal :price, null: false, default: 0.00, precision: 10, scale: 2, comment: '总价'
      t.decimal :discount, null: false, default: 0.00, precision: 10, scale: 2, comment: '折扣(元)'
      t.integer :status, default: 0, null: false, comment: '状态'
      t.string :name, comment: '名称'
      t.string :desc, comment: '描述'
      t.timestamps null: false
    end
  end
end
