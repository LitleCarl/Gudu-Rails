class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses, comment: '用户收货地址' do |t|
      t.string :name, comment: '收货人名'
      t.string :address, comment: '收货人地址'
      t.string :phone, comment: '收货人手机号'
      t.references :user, comment: '关联用户'
      t.timestamps null: false
    end
  end
end
