class ChangePingppInfoTypeOnPayment < ActiveRecord::Migration
  def change
    change_column :payments, :pingpp_info, :text
  end
end
