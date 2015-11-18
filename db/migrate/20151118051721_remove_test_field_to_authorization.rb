class RemoveTestFieldToAuthorization < ActiveRecord::Migration
  def change
    remove_column :authorizations, :test
  end
end
