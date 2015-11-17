# == Schema Information
#
# Table name: stores
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null                  # 店铺名称
#  brief          :string(255)      default("暂无简介"), not null # 店铺简介
#  address        :string(255)      not null                  # 商铺地址
#  logo_filename  :string(255)      not null                  # 商铺logo文件
#  location       :string(255)                                # location
#  pinyin         :string(255)                                # pinyin
#  status         :integer          default("1")              # 店铺状态
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  signature      :text(65535)                                # 店铺签名
#  month_sale     :integer          default("0")              # 月销量
#  back_ratio     :float(24)        default("0")              # 回头率,0-1
#  main_food_list :text(65535)                                # 主打商品名称列表
#  owner_id       :integer                                    # 关联商铺拥有人
#

require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
