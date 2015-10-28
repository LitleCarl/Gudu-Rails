module RestError
  class MissParameterError < StandardError
    def initialize(reason = '请求参数有误')
      super(reason)
    end
  end

end
