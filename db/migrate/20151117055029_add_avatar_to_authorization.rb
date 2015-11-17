class AddAvatarToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :avatar, :text, comment: '头像地址'
  end
end
