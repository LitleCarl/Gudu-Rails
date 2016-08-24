# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  status           :integer          default("1"), not null
#  price            :decimal(10, 2)   default("0.00"), not null # 总金额
#  delivery_time    :string(255)      not null
#  receiver_name    :string(255)      not null
#  receiver_phone   :string(255)      not null
#  receiver_address :string(255)      not null
#  campus_id        :integer
#  user_id          :integer
#  pay_method       :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  charge_json      :text(65535)                                # 订单关联charge
#  order_number     :string(255)                                # 订单编号
#  pay_price        :decimal(10, 2)   default("0.00")           # 实际支付金额
#  service_price    :decimal(10, 2)   default("0.00")           # 服务费用
#  print_count      :integer          default("0"), not null    # 小票打印次数
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
