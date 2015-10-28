class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users,comment: '用户表' do |t|
      t.string :phone, :null => false, comment: '用户手机'
      t.string :password, :null => false, :default => 'e10adc3949ba59abbe56e057f20f883e', comment: '用户密码 默认123456'
      t.timestamps null: false
    end
  end
end
