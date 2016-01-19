class CreateExpressers < ActiveRecord::Migration
  def change
    create_table :expressers do |t|
      t.string :name, null: false, comment: '快递员名字'
      t.string :phone, null: false, comment: '快递员手机'
      
      t.timestamps null: false
    end
  end
end
