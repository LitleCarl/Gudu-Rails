class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.string :image_name ,null: false, comment: '图片名'
      t.integer :priority ,default: 0, comment: '图片优先级'
      t.references :product
      t.timestamps null: false
    end
  end
end
