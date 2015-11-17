# == Schema Information
#
# Table name: body_infos
#
#  id         :integer          not null, primary key
#  height     :integer                                # 身高(CM)
#  weight     :integer                                # 体重(KG)
#  gender     :boolean          default("0")
#  user_id    :integer                                # 关联用户
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BodyInfo < ActiveRecord::Base
end
