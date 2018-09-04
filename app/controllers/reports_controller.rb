require 'will_paginate/array'
class ReportsController < ApplicationController

  before_action :authenticated_api_user

  def index
    param = {}
    [:from, :to, :phone_number, :location, :limit, :offset].each do |key|
      param[key] = params[key] if params[key]
    end
    # @reports = Service::request_report(session["email"], session["auth_token"], param)
    request = Service::request_report(session["email"], session["auth_token"], param)
    @reports = request.paginate(page: params[:page], per_page: 20)
  end
  
end
