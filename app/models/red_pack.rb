# == Schema Information
#
# Table name: red_packs
#
#  id         :integer          not null, primary key
#  expired_at :datetime         not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RedPack < ActiveRecord::Base

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
      red_pack, authorization = options[:red_pack_id], options[:authorization]

      res.__raise__(ResponseStatus::Code::ERROR, '红包不存在错误') if red_pack.blank?
      res.__raise__(ResponseStatus::Code::ERROR, '微信用户不存在错误') if authorization.blank?

      response, frozen_coupon = FrozenCoupon.generate_frozen_coupon({
                                                              red_pack: red_pack,
                                                              discount: 0.2,
                                                              least_price: 1,
                                                              authorization: authorization
                                                          })

    end

    return response, red_pack, frozen_coupon
  end

end
