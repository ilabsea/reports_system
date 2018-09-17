require 'will_paginate/array'
class ReportsController < ApplicationController

  before_action :authenticated_api_user

  def index
    param = {}
    [:from, :to, :phone_number, :location].each do |key|
      param[key] = params[key] if params[key]
    end
    # @reports = Service::request_report(session["email"], session["auth_token"], param)
    page = params[:page] || 0
    param[:limit] = page_size
    param[:offset] = page_size * (page.to_i - 1)
    begin
      request = Service::request_report(session["email"], session["auth_token"], param)
      @reports = request.paginate(page: params[:page], per_page: page_size)
    rescue
      flash[:error] = "System failed to connect to Verboice!"
      @reports = [].paginate(page: params[:page], per_page: page_size)
    end
  end

  private

  def page_size
    Settings.default_page_size || 10
  end
  
end
