# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  address         :string(255)
#  phone           :string(255)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_address :boolean          default("0")
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
