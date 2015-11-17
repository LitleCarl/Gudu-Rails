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
#

class Campus < ActiveRecord::Base
  self.table_name = 'campuses'
  has_many :stores_campuses
  has_many :stores, through: :stores_campuses
  belongs_to :city

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
