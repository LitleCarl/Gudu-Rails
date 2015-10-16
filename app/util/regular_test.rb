class RegularTest
  def self.is_phone_number(phone)
    if phone =~ /^[1]+[3,5,7,8]+\d{9}$/
      true
    else
      false
    end
  end
end