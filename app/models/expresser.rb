# == Schema Information
#
# Table name: expressers
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null              # 快递员名字
#  phone      :string(255)      not null              # 快递员手机
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expresser < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

end
