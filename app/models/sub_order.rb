# == Schema Information
#
# Table name: sub_orders
#
#  id          :integer          not null, primary key
#  owner_id    :integer          not null
#  order_id    :integer          not null
#  price       :decimal(10, 2)   default("0.00"), not null
#  origin_date :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SubOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :owner
end
