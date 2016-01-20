class AddPasswordToExpresser < ActiveRecord::Migration
  def change
    add_column :expressers, :password, :string, default: '123456', comment: '密码'

    change_column :expressers, :phone, :string, unique: true, comment: '手机号'
  end
end
