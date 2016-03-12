class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.text :content, comment: '通知内容'
      t.string :link, comment: '链接地址'
      t.integer :platform, default: 0, comment: '平台'
      
      t.timestamps null: false
    end
  end
end
