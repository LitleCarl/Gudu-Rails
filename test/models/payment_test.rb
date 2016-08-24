# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  payment_method :string(255)      not null
#  time_paid      :datetime         not null
#  amount         :decimal(10, 2)   default("0.00"), not null # 支付总金额
#  transaction_no :string(255)      not null                  # 交易号
#  charge_id      :string(255)      not null                  # charge id
#  order_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pingpp_info    :text(65535)                                # pingpp返回json
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
