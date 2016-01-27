# == Schema Information
#
# Table name: stores_campuses
#
#  id         :integer          not null, primary key
#  store_id   :integer
#  campus_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StoresCampus < ActiveRecord::Base
  belongs_to :store
  belongs_to :campus
end
