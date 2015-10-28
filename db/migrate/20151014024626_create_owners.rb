class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :username, null: false, unique: true
      t.string :password, null: false, default: 'e10adc3949ba59abbe56e057f20f883e'
      t.string :contact_name, null: false
      t.string :contact_phone, null: false

      t.timestamps null: false
    end
  end
end
