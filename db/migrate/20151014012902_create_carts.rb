class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user, comment:'关联用户'
      t.timestamps null: false
    end
  end
end
