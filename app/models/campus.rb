# == Schema Information
#
# Table name: campuses
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null              # 校名
#  address       :string(255)      not null              # 学校地址
#  logo_filename :string(255)                            # 学校logo
#  city_id       :integer                                # 地址城市
#  location      :string(255)                            # 地址坐标
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  first_letter  :string(255)                            # 学校名称拼音首字母
#

class Campus < ActiveRecord::Base
  self.table_name = 'campuses'

  before_save :update_first_letter

  # 关联店铺中间表
  has_many :stores_campuses

  # 关联店铺
  has_many :stores, through: :stores_campuses

  # 关联城市
  belongs_to :city

  def update_first_letter
    if self.changed.include?('first_letter')
      self.first_letter = (HanziToPinyin.hanzi_to_pinyin(self.name)[0] || '#').upcase
    end
  end

  def self.get_campus_detail(params)
    response_status = ResponseStatus.default_success
    begin
      data = self.find(params[:campus_id])
    rescue ActiveRecord::RecordNotFound
      response_status = ResponseStatus.no_data_found
    end
      return response_status, data
  end

  def self.get_all_campuses(params)
    response_status = ResponseStatus.default_success
    data = self.all
    return response_status, data
  end

end
