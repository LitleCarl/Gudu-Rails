# == Schema Information
#
# Table name: red_packs
#
#  id         :integer          not null, primary key
#  expired_at :datetime         not null              # 过期时间
#  user_id    :integer          not null              # 关联用户
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer                                # 红包关联订单
#

class RedPack < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联用户
  belongs_to :user

  # 关联订单
  belongs_to :order

  # 关联暂存红包
  has_many :frozen_coupons

  #
  # 查询有效的红包
  #
  # @param options [Hash] 约束
  #
  # @return [RedPack] 红包
  #
  def self.query_activacted_first_by_options(options)
    result = self.where('expired_at > ?', Time.now)
    result.where(options) if options.present?
    result.first
  end

  # 从一个红包生成一个frozen coupon
  def self.generate_frozen_coupon_by_options(options)
    frozen_coupon = nil
    red_pack = nil

    catch_proc = proc{
      frozen_coupon = nil
      red_pack = nil
    }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      red_pack_id, authorization = options[:red_pack_id], options[:authorization]
      red_pack = self.query_by_options(id: red_pack_id).where('expired_at > ?', Time.now).first

      res.__raise__(ResponseStatus::Code::ERROR, '红包不存在错误') if red_pack.blank?
      res.__raise__(ResponseStatus::Code::ERROR, '微信用户不存在错误') if authorization.blank?

      #查找是否已经给此用户过红包
      frozen_coupon = FrozenCoupon.where(red_pack: red_pack, authorization: authorization)

      res.__raise__(ResponseStatus::Code::ERROR, '您已经领过此红包，不能重复领取') if frozen_coupon.present?

      response, frozen_coupon = FrozenCoupon.generate_frozen_coupon({
                                                              red_pack: red_pack,
                                                              discount: 0.2,
                                                              least_price: 1,
                                                              authorization: authorization
                                                          })
      res.__raise__response__(response)

    end

    return response, red_pack, frozen_coupon
  end

end
