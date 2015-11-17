class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :text, comment: '用户头像'
  end
end
