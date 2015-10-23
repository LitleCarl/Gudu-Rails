class AddPingppWebHookInfoToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :pingpp_info, :string, comment: 'pingpp返回json'
  end
end
