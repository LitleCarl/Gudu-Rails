class AwardCouponSmsWorker

  # 您的订单已经发货成功
  def self.perform(users = [])
    # users.each do |user|
    #   options = {
    #       discount: 2,
    #       least_price: 6,
    #       activated_date: Time.now,
    #       expired_date: Time.now + 3.days,
    #       user: user
    #   }
    #   Coupon.generate_coupon(options)
    #   options[:discount] = 3
    #   options[:least_price] = 8
    #   Coupon.generate_coupon(options)
    #
    # end

    if users.count > 0
      Sms.sms_alidayu(users.map(&:phone).join(','), Sms::TemplateID::ALI_COUPON_AWARD, {name: '会员', value:'5元'})
    end
    # Sms.sms_alidayu('18818226831,18818224319,18818224358,18817942674,18621780817,18993706841,18818223800,18818226763,13122898062,18818224653,18818226726,18818226388,15821769706,18801731528,18818262582,15216731476,18047669797,15900948369,15618997689,13661647356,18818262212,18818226816,18818226753,15201829040,13918727728,13524229739,18818224629,18818223900,13122898910,13611991143,18817943599,18702106496,13816593762,18818226727,18818223898,13817458401,15021349837,13661960772,15201733489,15821507013,13382620998,15221587408,13817458702,15000884557,15021082644,18818252152,13120722217,18818262804,18818262873,18321080337,15102150119,13166040691,13641665787,18818224649,15000721239,18817943356,15821627838,13611641787,13761877394,18701729241,13482694501,15821553182,13482796015,15000867001,13817203230,18818226715,13918003582,13918562651,13795497980,18698881051,18818226749,13922806829,18347301557,13816800046,18793385648,13916369375,13524004193,18817943307,18818223881,18817942654,13918400976,18818224365,15901567568,18818226801,18817943350,18818226806,15821330846,15502124580,15021580368,18818224617,18818226569,13061819569,13120825713,18817849003,18818262024,13122239075,18818223821,18818224328,18818224681,18818226837,18818224616,18818226889,18951333212,13524764543,18818224659,15000182420,13817315824,13564820051,18818226557,18818224670,18910358679,18321160085,18817578496,15300866606,13585676943,18800598593,18801731764,15800932691,13917637468,15921697942,18512144393', 'SMS_10255690', {area: '上海理工有早餐外卖啦,关注公众号:早餐巴士,免费送上门哦.'})
  end
end