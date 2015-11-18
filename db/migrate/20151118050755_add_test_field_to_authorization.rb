class AddTestFieldToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :test, :string
  end
end
