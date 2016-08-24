# == Schema Information
#
# Table name: addresses # 用户收货地址
#
#  id              :integer          not null, primary key # 用户收货地址
#  name            :string(255)                            # 收货人名
#  address         :string(255)                            # 收货人地址
#  phone           :string(255)                            # 收货人手机号
#  user_id         :integer                                # 关联用户
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_address :boolean          default("0")          # 默认收货地址
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
