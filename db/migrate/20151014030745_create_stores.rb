class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name, null: false, comment: '店铺名称'
      t.string :brief, null: false, default: '暂无简介', comment: '店铺简介'
      t.string :address, null: false, comment: '商铺地址'
      t.string :logo_filename, null: false, comment: '商铺logo文件'
      t.string :location,  comment: 'location'
      t.string :pinyin,  comment: 'pinyin'
      t.integer :status, default: 1 , comment: '店铺状态'
      t.timestamps null: false
    end
  end
end
