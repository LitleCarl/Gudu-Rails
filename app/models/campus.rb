# == Schema Information
#
# Table name: campuses
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  address       :string(255)      not null
#  logo_filename :string(255)
#  city_id       :integer
#  location      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  first_letter  :string(255)                            # 学校名称拼音首字母
#

class Campus < ActiveRecord::Base
  self.table_name = 'campuses'

  # 通用查询方法
  include Concerns::Query::Methods

  before_save :update_first_letter

  # 关联店铺中间表
  has_many :stores_campuses

  # 关联店铺
  has_many :stores, through: :stores_campuses

  # 关联城市
  belongs_to :city

  def update_first_letter
    if self.changed.include?('name')
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

  #
  # 获取学校学校列表,可指定关键字
  #
  # @param options [Hash]
  # option options [String] :keyword 关键字
  #
  # @return [Response, Array] 状态，学校列表
  #
  def self.get_all_campuses(options)
    campuses = []
    catch_proc = proc { campuses = [] }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      if options[:keyword].present?
        campuses = self.query_by_options(like_name: options[:keyword])
      else
        campuses = self.all
      end
    end

    return response, campuses
  end

  #
  # 获取学校周围所有的店铺的一天早餐统计
  #
  # @param options [Hash]
  # option options [Date] :date 天
  #
  # @return [Response, Array] 状态，stores_time_to_order_array 格式如[{store:xx, data: {'7:30': {'{specification_1}': quantity}}]
  #
  def self.statistic_for_date(options)
    stores_time_to_specification_to_quantity_array = []
    campus = nil

    response = ResponseStatus.__rescue__ do |res|

      manager, date = options[:manager],options[:date]
      if date.present?
        date = Date.parse date
      else
        date = Time.now
      end

      puts "manager.phone#{manager.phone}"

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || date.blank?

      campus = manager.campus

      res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if campus.blank?

      campus.stores.each do|store|
        inner_response, deliver_time_to_specification_to_quantity_hash= store.orders_at_date({date: date})

        res.__raise__response__(inner_response)

        stores_time_to_specification_to_quantity_array << {data: deliver_time_to_specification_to_quantity_hash, store: store}
      end
    end

    return response, stores_time_to_specification_to_quantity_array, campus
  end

end
