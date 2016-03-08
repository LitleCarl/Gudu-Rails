# encoding: UTF-8

# https://github.com/kickstarter/rack-attack
class Rack::Attack

  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blacklisting and
  # whitelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store

  # Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new

  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 130, :period => 1.minutes) do |req|
    req.ip unless req.path.start_with?('/assets')
  end

  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  # throttle('logins/ip', :limit => 5, :period => 20.seconds) do |req|
  #   if req.path == '/login' && req.post?
  #     req.ip
  #   end
  # end

  # 貌似，不起作用，throttle 的配置特定 URL 不起作用，限定特定 ip 的去起作用
  # 备注: throttle 控制的键的生成，其实现是通过缓存进行访问计数，超过计数的则截断返回内容
  # throttle('products', limit: 2, period: 1.minutes) do |req|
  #   Rails.logger.info 'enter products details!'
  #   if req.path == '/products' && req.get?
  #     # return the email if present, nil otherwise
  #     req.params['code']
  #   end
  # end

  # Supports optional limit and period, triggers the notification only when the limit is reached.
  # Rack::Attack.track('products', limit: 2, period: 1.minutes) do |req|
  #   if /products\/\d+/.match(req.path) && req.get?
  #     params['code']
  #   end
  # end

  # Track it using ActiveSupport::Notification
  # ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, req|
  #   current_user.logout
  #   reset_session
  #   del_user_cookies
  #   logger sign_out_users_url
  #   Nestful.get(sign_out_users_url)
  # end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  self.throttled_response = lambda do |env|

    retry_after = (env['rack.attack.match_data'] || {})[:period]

    response = ResponseStatus.default_access_limit

    [429, {'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s}, [
        {
            status: {
                code: response.code,
                message: response.message
            }
        }.to_json
    ]]
  end

  # def self.get_response_html
  #   html_path = "#{Rails.root.to_s}/app/views/homes/429.html.slim"
  #   Slim::Template.new(html_path).render(self)
  # end
end