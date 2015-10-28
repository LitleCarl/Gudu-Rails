class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.datetime :active_from, null: false
      t.datetime :active_to, null: false
      t.references :store, null:false
      t.timestamps null: false
    end
  end
end
