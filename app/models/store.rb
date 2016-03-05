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
#  owner_id       :integer
#  boost          :integer          default("0"), not null    # 店铺权重
#

class Store < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # mixin 管理者
  include Concerns::Management::Api::V1::StoreConcern

  # 商城有一个拥有着
  belongs_to :owner

  # 中间表
  has_many :stores_campuses

  # 商城可以关联多个学校
  has_many :campuses, through: :stores_campuses

  # 商城关联合同
  has_one :contract

  # 商城关联商品
  has_many :products

  # 关联商铺菜品分类
  has_many :categories

  # 商铺logo挂载
  mount_uploader :logo_filename, ImageUploader

  # 设置拼音
  before_save :set_store_pinyin

  module Status
    include Concerns::Dictionary::Module::I18n

    Pending = 1  # 暂停

    Normal = 2 # 正常

    Suspend = 3 # 停止(合同到期)

    # 全部
    ALL = get_all_values
  end

  def self.get_stores_in_campus(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:campus_id].blank?
      data = Campus.find(params[:campus_id]).stores.includes(:products => [:specifications, :nutrition, :product_images]).where('status = ?', Store::Status::Normal).order('created_at desc').page(params[:page]).per(params[:limit])
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
      data = Store.where(:id => params[:store_id]).includes(products: :specifications).references(:products, :specifications).first
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

  # 随机选择一家校区范围内的店铺
  def self.recommend_store_in_campus(options)
    store = nil

    response = ResponseStatus.__rescue__ do |res|
      res.__raise__(ResponseStatus::Code::MISS_PARAM, '参数错误') if options[:campus_id].blank?

      stores = Campus.query_first_by_id(options[:campus_id]).stores
      count = stores.count
      if count > 0
        index = rand count
        store = stores[index]
      else
        res.__raise__(ResponseStatus::Code::ERROR, '该学校还没有店铺哦')
      end
    end

    return response, store
  end

  # 根据关键字模糊搜索指定学校里的店铺
  def self.search_store_by_keyword(campus_id, keyword)
    keyword = "'%#{keyword.downcase}%'"
    self.includes(:campuses).references(:campuses).where({campuses: {id: campus_id}}).where('stores.status = ?', Status::Normal).where("stores.name like #{keyword} or stores.pinyin like #{keyword}")
  end

  #
  # 刷店铺的招牌菜列表
  #
  # Console方法
  #
  def self.run_main_food_list_program(list = nil)
    list ||= Store.all
    list.each do |store|
      store.main_food_list = store.products.order('month_sale DESC').limit(9).pluck(:name).join(' ')
      store.save!
    end
  end

  ########################################################################
  #
  #
  #                         实例方法区域
  #
  #                        Instance Method
  #
  #
  ########################################################################

  # 如果店铺菜单没有此分类,则新建一个分类
  #
  # @param category_name [String]
  #
  # @return [ResponseStatus, Category] response, category
  #
  def upsert_category(category_name)
    category = self.categories.where(name: category).first

    if category.blank?

      catch_proc = proc { category = nil }

      response = ResponseStatus.__rescue__(catch_proc) do |res|
        category = Category.new
        category.name = category_name
        category.priority = 0
        category.store = self
        category.save!
      end
    else
      response = ResponseStatus.default_success
    end

    return response, category
  end

  #
  # 更新店铺回头率,计算方式:
  # 查找所有关于本店铺的Order下的OrderItem的Product并属于本店铺的
  #
  def update_back_ratio
    order_ids = Order.joins(order_items: :product).references(:products).where('products.store_id = ?', 1).distinct.map(&:id)
    result = Order.where(:id => order_ids).select('count(*) as count, user_id').group(:user_id)

    # 用户基数
    base_num = result.to_a.count
    # 回头客数
    back_num = result.having('count > 1').to_a.count
    # 回头率
    if base_num == 0
      back_ratio = 0.0
    else
      back_ratio = back_num / base_num.to_f
    end

    self.back_ratio = back_ratio
    self.save
  end

  # validate 设置拼音
  def set_store_pinyin
    if self.changed.include?('name')
      self.pinyin = Pinyin.t(self.name, splitter: '').downcase
    end
  end
end
