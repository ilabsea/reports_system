require 'will_paginate/array'

class ReportsController < ApplicationController
  before_action :filter_params, only: [:index]
  before_action :csv_options, only: [:index], if: :csv_request?

  def index
    begin
      @reports = Service::Report.where(@filter_params)
      @reports = @reports.paginate(page: params[:page], per_page: page_size) if html_request?
    rescue
      flash[:error] = t('report.failed_connect_verboice')
    end

    respond_to do |format|
      format.html
      format.csv
      format.xlsx { 
        response.headers['Content-Disposition'] = "attachment; filename='reports-#{Time.now}.xlsx'"
      }
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

  def csv_options
    @csv_options = { :force_quotes => true, :col_sep => ',' }
    @output_encoding = 'UTF-8'
    @filename = "reports-#{Time.now}.csv"
  end

  def html_request?
    request.format.html?
  end

  def csv_request?
    request.format.csv?
  end
  
end
