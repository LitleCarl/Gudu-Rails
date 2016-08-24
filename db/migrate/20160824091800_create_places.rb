class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, comment: '收货地点'
      t.integer :campus_id, comment: '关联学校'
      t.timestamps null: false
    end
  end
end
