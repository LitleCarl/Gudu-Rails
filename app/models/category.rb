# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 分类名称
#  priority   :integer                                # 显示顺序(>=0)
#  store_id   :integer                                # 关联店铺
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
end
