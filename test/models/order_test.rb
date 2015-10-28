# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  status           :integer          default("1"), not null
#  price            :decimal(10, 2)   default("0.00"), not null
#  delivery_time    :string(255)      not null
#  receiver_name    :string(255)      not null
#  receiver_phone   :string(255)      not null
#  receiver_address :string(255)      not null
#  campus_id        :integer
#  user_id          :integer
#  pay_method       :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  charge_json      :text(65535)
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
