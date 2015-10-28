class AddDefaultAddressToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :default_address, :boolean, default: false, comment: '默认收货地址'
  end
end
