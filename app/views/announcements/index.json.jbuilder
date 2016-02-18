json.partial! "api/status", response_status: @response_status

json.data do | json |
  json.announcement do | json |
    if @announcement.present?
      json.partial! "announcements/announcement", announcement: @anouncement
    else
      json.nil!
    end
  end
end