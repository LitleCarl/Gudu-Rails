# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  store_id      :integer          not null
#  name          :string(255)      not null               # 商品名
#  logo_filename :string(255)      not null               # 商品logo缩略图
#  brief         :string(255)      default("暂无简介")        # 商品简介
#  min_price     :string(255)      default("0.0")         # 规格中最低价
#  max_price     :string(255)      default("0.0")         # 规格中最高价
#  category      :string(255)      not null               # 商品分类,"饮料"
#  status        :integer          default("1"), not null
#  pinyin        :string(255)                             # 拼音
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  month_sale    :integer          default("23")          # 月售
#

class Product < ActiveRecord::Base

  belongs_to :store

  has_one :nutrition

  has_many :specifications

  has_many :product_images

  # 拼音
  before_save :set_pinyin, :set_default_brief

  module Status
    Normal = 1  # 上架
    Pending = 2 # 下架
  end

  # 根据id获取商品详情
  def self.get_product_detail_by_id(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:product_id].blank?
      data = Product.where(:id => params[:product_id]).includes(:specifications).references(:specifications).where('specifications.status = ?', Specification::Status::Normal)
      response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, data
  end

  def self.search_product_for_api(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:campus_id].blank? || params[:keyword].blank?
      data = self.search_product_by_keyword(params[:campus_id], params[:keyword])
      response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, data
  end

  # 根据关键字模糊搜索指定学校里的商品
  def self.search_product_by_keyword(campus_id, keyword)
    keyword = "'%#{keyword.downcase}%'"
    self.includes(:store => :campuses).references(:campuses).where({campuses: {id: campus_id}}).where("products.name like #{keyword} or products.pinyin like #{keyword}")
  end

  # 设置拼音
  def set_pinyin
    if self.changed.include?('name')
      self.pinyin = Pinyin.t(self.name, splitter: '').downcase
    end
  end

  def set_default_brief
    self.brief ||= '暂无简介'
  end

end
