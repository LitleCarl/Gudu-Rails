# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  payment_method :string(255)      not null
#  time_paid      :datetime         not null
#  amount         :decimal(10, 2)   default("0.00"), not null
#  transaction_no :string(255)      not null
#  charge_id      :string(255)      not null
#  order_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
