# == Schema Information
#
# Table name: body_infos
#
#  id         :integer          not null, primary key
#  height     :integer
#  weight     :integer
#  gender     :boolean          default("0")
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BodyInfo < ActiveRecord::Base
end
