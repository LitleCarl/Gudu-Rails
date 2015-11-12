class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :open_id, comment: 'open id'
      t.string :provider, comment: '提供者(wx,weibo)'
      t.string :token, comment: '令牌'
      t.string :refresh_token, comment: '刷新令牌'

      t.string :open_id, comment: 'open id'
      t.timestamps null: false
    end
  end
end
