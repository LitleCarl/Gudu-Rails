class AddNameToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :nick_name, :string, comment: '第三方昵称'
  end
end
