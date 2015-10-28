class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, unique: true, null: false
      t.string :abbreviation
      t.timestamps null: false
    end
  end
end
