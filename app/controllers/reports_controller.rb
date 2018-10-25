require 'will_paginate/array'

class ReportsController < ApplicationController
  before_action :filter_params, only: [:index]

  def index
    begin
      @reports  = Service::Report.where(@filter_params).paginate(page: params[:page], per_page: page_size)
    rescue
      flash[:error] = "Failed to connect to Verboice!"
      @reports = [].paginate(page: params[:page], per_page: page_size)
    end
  end

  # PUT reports/:id
  def update
    begin
      report = Service::Report.update(params[:id], report: protected_params)
      render json: report
    rescue
      render json: '', status: 422
    end
  end

  private

  def protected_params
    params.require(:report).permit(:location, :properties => [:case, :symptom => []])
  end

  def filter_params
    @filter_params = {}
    [:from, :to, :phone_number, :location].each do |key|
      @filter_params[key] = params[key] if params[key]
    end

    page = params[:page] || 0
    @filter_params[:limit] = page_size
    @filter_params[:offset] = page_size * (page.to_i - 1)
  end

  def page_size
    Settings.default_page_size || 10
  end
  
end
