# encoding: utf-8

class Object

  #
  # 添加统一处理时间字段的方法
  #
  def to_json_time
    self.strftime('%Y-%m-%d %H:%M:%S')
  end

  #
  # 添加统一处理日期字段的方法
  #
  def to_json_date
   self.strftime('%Y-%m-%d')
  end
end
