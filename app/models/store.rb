# == Schema Information
#
# Table name: stores
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  brief         :string(255)      default("暂无简介"), not null
#  address       :string(255)      not null
#  logo_filename :string(255)      not null
#  location      :string(255)
#  pinyin        :string(255)
#  status        :integer          default("1")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Store < ActiveRecord::Base
  belongs_to :owner

  has_many :stores_campuses
  has_many :campuses, through: :stores_campuses
  has_one :contract
  has_many :products
  before_save :set_store_pinyin

  module Status
    Pending = 1  # 暂停
    Normal = 2 # 正常
    Suspend = 3 # 停止(合同到期)
  end

  def self.get_stores_in_campus(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      puts "params",params
      raise RestError::MissParameterError if params[:campus_id].blank?
      data = Campus.find(params[:campus_id]).stores.order('created_at desc').page(params[:page]).per(params[:limit])
      response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, data
  end

  # 设置拼音
  def set_store_pinyin
    if self.changed.include?('name')
      self.pinyin = HanziToPinyin.hanzi_to_pinyin(self.name).upcase
    end
  end
end
