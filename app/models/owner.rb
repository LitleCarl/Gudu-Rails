# == Schema Information
#
# Table name: owners
#
#  id            :integer          not null, primary key
#  username      :string(255)      not null
#  password      :string(255)      default("e10adc3949ba59abbe56e057f20f883e"), not null
#  contact_name  :string(255)      not null
#  contact_phone :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Owner < ActiveRecord::Base
  has_one :store
  has_many :sub_orders

  before_save :set_password_encrypted

  def set_password_encrypted
    if self.changed.include?('password')
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end
end
