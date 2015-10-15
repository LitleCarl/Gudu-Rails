class CampusesController < ApplicationController
  skip_before_filter :user_about

=begin
@api {get} /campuses/:id 获取用户订单列表
@apiName GetCampusDetail
@apiGroup Campus

@apiSuccess {Hash}  campus 学校
=end
  def show
    @response_status, @data = Campus.get_campus_detail(params)
  end

=begin
@api {get} /campuses 获取用户订单列表
@apiName GetCampuses
@apiGroup Campus

@apiSuccess {Array}  campuses 学校列表
=end
  def index
    @response_status, @data = Campus.get_all_campuses(params)
  end
end
