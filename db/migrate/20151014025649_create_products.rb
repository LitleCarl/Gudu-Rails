class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :store, null: false
      t.string :name ,null: false, comment: '商品名'
      t.string :logo_filename ,null: false, comment: '商品logo缩略图'
      t.string :brief ,null: false, comment: '商品简介'
      t.string :min_price ,null: false, comment: '规格中最低价'
      t.string :max_price ,null: false, comment: '规格中最高价'
      t.string :category ,null: false, comment: '商品分类,"饮料"'
      t.integer :status, default: 1, null: false
      t.string :pinyin, comment: '拼音'
      t.timestamps null: false
    end
  end
end
