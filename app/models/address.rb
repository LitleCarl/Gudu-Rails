# == Schema Information
#
# Table name: addresses # 用户收货地址
#
#  id              :integer          not null, primary key # 用户收货地址
#  name            :string(255)                            # 收货人名
#  address         :string(255)                            # 收货人地址
#  phone           :string(255)                            # 收货人手机号
#  user_id         :integer                                # 关联用户
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_address :boolean          default("0")          # 默认收货地址
#

class Address < ActiveRecord::Base
  belongs_to :user
  #validates_uniqueness_of
  validates :name, :address, :phone, :user_id, presence: true
  validate :check_fields
  after_save :detect_address_is_set_default

  def self.add_address(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:name].blank? || params[:phone].blank? || params[:address].blank?
      address = Address.new
      address.name = params[:name]
      address.phone = params[:phone]
      address.address = params[:address]
      address.user = params[:user]
      address.save!()
      response_status = ResponseStatus.default_success
      data = address
    rescue Exception => ex
      Rails.logger.error(ex.message)
    end
    return response_status, data
  end

  def self.delete_address(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      raise RestError::MissParameterError if params[:address_id].blank?
      user = params[:user]
      if user.present?
        address = Address.find(params[:address_id]).where({user_id: user.id}).first
        if address.present?
          address.destroy!()
          response_status = ResponseStatus.default_success
          data = address
        else
          response_status.message = '地址不存在'
        end
      end

    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = '地址删除失败'
    end
    return response_status, data
  end

  def self.update_address(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      address_param = params[:address]
      raise RestError::MissParameterError if address_param.blank? || address_param[:name].blank? || address_param[:phone].blank? || address_param[:address].blank?
      user = params[:user]
      if user.present?
        address = Address.where({user_id: user.id, id: params[:address_id]}).first
        if address.present?
          address.name = address_param[:name]
          address.phone = address_param[:phone]
          address.address = address_param[:address]
          address.default_address = address_param[:default_address]
          address.save!
          response_status = ResponseStatus.default_success
          data = address
        else
          response_status.message = '地址不存在'
        end

      end
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = '地址修改失败'
    end
    return response_status, data
  end

  def check_fields
    self.default_address ||= false
  end
  # 检测地址的默认地址属性是否修改过
  def detect_address_is_set_default
    if self.changed.include?('default_address') && self.default_address == true
      Address.where({default_address: true, user_id: self.user_id}).where.not({id: self.id}).each do | address |
        address.default_address = false
        address.save
      end
    end
  end

end
