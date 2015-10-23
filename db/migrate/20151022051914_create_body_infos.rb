class CreateBodyInfos < ActiveRecord::Migration
  def change
    create_table :body_infos do |t|
      t.integer :height, comment: '身高(CM)'
      t.integer :weight, comment: '体重(KG)'
      t.boolean :gender, default: 0, commnt: '性别,1->男,2->女'
      t.references :user, comment: '关联用户'
      t.timestamps null: false
    end
  end
end
