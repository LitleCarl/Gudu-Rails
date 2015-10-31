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
      raise RestError::MissParameterError if params[:campus_id].blank?
      data = Campus.find(params[:campus_id]).stores.where('status = ?', Store::Status::Normal).order('created_at desc').page(params[:page]).per(params[:limit])
      response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, data
  end

  def self.get_store_by_id(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:store_id].blank?
      data = Store.where(:id => params[:store_id]).includes(:products).references(:products).where('products.status = ?', Product::Status::Normal).first
      response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, data
  end

  def self.search_store_for_api(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:campus_id].blank? || params[:keyword].blank?
      data = self.search_store_by_keyword(params[:campus_id], params[:keyword])
      response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, data
  end

  # 根据关键字模糊搜索指定学校里的店铺
  def self.search_store_by_keyword(campus_id, keyword)
    keyword = "'%#{keyword.downcase}%'"
    self.includes(:campuses).references(:campuses).where({campuses: {id: campus_id}}).where("stores.name like #{keyword} or stores.pinyin like #{keyword}")
  end

  # validate 设置拼音
  def set_store_pinyin
    if self.changed.include?('name')
      self.pinyin = Pinyin.t(self.name, splitter: '').downcase
    end
  end
end
