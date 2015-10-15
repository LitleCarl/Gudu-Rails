class CreateCampus < ActiveRecord::Migration
  def change
    create_table :campuses do |t|
      t.string :name, :null => false, comment: '校名'
      t.string :address, :null => false, comment: '学校地址'
      t.string :logo_filename, comment: '学校logo'
      t.references :city, comment:'地址城市'
      t.string :location, comment:'地址坐标'

      t.timestamps null: false
    end
  end
end
