# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 收货地点
#  campus_id  :integer                                # 关联学校
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Place < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联学校
  belongs_to :campus

end
