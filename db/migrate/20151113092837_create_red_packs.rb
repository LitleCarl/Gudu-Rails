class CreateRedPacks < ActiveRecord::Migration
  def change
    create_table :red_packs do |t|

      t.datetime :expired_at, null: false, comment: '过期时间'
      t.belongs_to :user, null: false, comment: '关联用户'

      t.timestamps null: false
    end
  end
end
