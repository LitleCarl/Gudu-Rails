# == Schema Information
#
# Table name: contracts
#
#  id          :integer          not null, primary key
#  active_from :datetime         not null
#  active_to   :datetime         not null
#  store_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
