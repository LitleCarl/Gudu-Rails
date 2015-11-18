class ChangeAuthorizationTable < ActiveRecord::Migration
  def change
    remove_column :authorizations, :token, :string
    remove_column :authorizations, :refresh_token, :string
    remove_column :authorizations, :open_id, :string

    add_column :authorizations, :gzh_token, :string, comment: '公众号token'
    add_column :authorizations, :gzh_refresh_token, :string, comment: '公众号refresh_token'
    add_column :authorizations, :open_token, :string, comment: '开放平台token'
    add_column :authorizations, :open_refresh_token, :string, comment: '开放平台refresh_token'
    add_column :authorizations, :gzh_open_id, :string, comment: '公众号open_id'
    add_column :authorizations, :open_open_id, :string, comment: '开放平台open_id'

  end
end
