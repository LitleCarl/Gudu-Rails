class RemoveCampusesIdForOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :campuses_id, :campus_id
  end
end
