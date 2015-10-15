# == Schema Information
#
# Table name: campuses
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  addresses       :string(255)      not null
#  logo_filename :string(255)
#  city_id       :integer
#  location      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CampuTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
