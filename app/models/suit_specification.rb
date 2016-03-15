# == Schema Information
#
# Table name: suit_specifications
#
#  id               :integer          not null, primary key
#  suit_id          :integer                                # 关联套餐
#  specification_id :integer                                # 关联规格
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SuitSpecification < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联套餐
  belongs_to :suit

  # 关联规格
  belongs_to :specification

end
