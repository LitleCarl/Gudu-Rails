# == Schema Information
#
# Table name: stores_campuses
#
#  id         :integer          not null, primary key
#  store_id   :integer                                # 关联商铺
#  campus_id  :integer                                # 关联校区
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StoresCampus < ActiveRecord::Base
  belongs_to :store
  belongs_to :campus
end
