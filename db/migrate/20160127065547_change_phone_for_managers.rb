class ChangePhoneForManagers < ActiveRecord::Migration
  def change
    change_column :managers, :phone, :string, null: false, default: ''
  end
end
