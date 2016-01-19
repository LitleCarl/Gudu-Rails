class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :phone, null: false, unique: true, comment: '手机号'
      t.references :campus, comment: '所属校区'
      t.boolean :write, comment: '修改权限'
      t.timestamps null: false
    end
  end
end
