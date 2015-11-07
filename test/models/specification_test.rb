# == Schema Information
#
# Table name: specifications
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  value         :string(255)      not null
#  price         :decimal(10, 2)   default("0.00"), not null
#  product_id    :integer          not null
#  status        :integer          default("1"), not null
#  stock         :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stock_per_day :integer          default("10"), not null
#

require 'test_helper'

class SpecificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
