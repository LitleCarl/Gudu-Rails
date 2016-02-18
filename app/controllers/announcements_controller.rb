class AnnouncementsController < ApplicationController
  skip_before_filter :user_about

  def index
    @response_status, @anouncement = Announcement.query_newest_with_options(params)
  end

end
