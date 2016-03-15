# == Schema Information
#
# Table name: suits
#
#  id            :integer          not null, primary key
#  campus_id     :integer                                    # 关联学校
#  price         :decimal(10, 2)   default("0.00"), not null # 总价
#  discount      :decimal(10, 2)   default("0.00"), not null # 折扣(元)
#  status        :integer          default("0"), not null    # 状态
#  name          :string(255)                                # 名称
#  desc          :string(255)                                # 描述
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  logo_filename :string(255)                                # 套餐图片
#

class Suit < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联学校
  belongs_to :campus

end
