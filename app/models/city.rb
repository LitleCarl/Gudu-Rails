# == Schema Information
#
# Table name: cities
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  abbreviation :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class City < ActiveRecord::Base
  has_many :campuses
  before_save :set_pinyin_abbreviation

  # 设置拼音
  def set_pinyin_abbreviation
    if self.changed.include?('name')
      self.abbreviation = HanziToPinyin.hanzi_to_pinyin(self.name).upcase
    end
  end
end
