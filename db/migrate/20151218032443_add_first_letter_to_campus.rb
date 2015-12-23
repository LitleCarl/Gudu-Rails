class AddFirstLetterToCampus < ActiveRecord::Migration
  def change
    add_column :campuses, :first_letter, :string, comment: '学校名称拼音首字母'
  end
end
