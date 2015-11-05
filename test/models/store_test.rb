# == Schema Information
#
# Table name: stores
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  brief          :string(255)      default("暂无简介"), not null
#  address        :string(255)      not null
#  logo_filename  :string(255)      not null
#  location       :string(255)
#  pinyin         :string(255)
#  status         :integer          default("1")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  signature      :text(65535)
#  month_sale     :integer          default("0")
#  back_ratio     :float(24)        default("0")
#  main_food_list :text(65535)
#  owner_id       :integer
#

require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
