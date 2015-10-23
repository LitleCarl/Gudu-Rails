class CreateStoresCampuses < ActiveRecord::Migration
  def change
    create_table :stores_campuses do |t|
      t.references :store, comment: '关联商铺'
      t.references :campus, comment: '关联校区'
      t.timestamps null: false
    end
  end
end
