# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  phone      :string(255)      not null
#  password   :string(255)      default("e10adc3949ba59abbe56e057f20f883e"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_many :orders
  has_many :addresses
  has_one :cart
end
