class WitAiUploadsController < ApplicationController
  before_action :authenticated_api_user

  def index
  end

  def confirm_import
    @file_path = Service::generate_file_path params[:file_name]
    data =  Spreadsheet.open @file_path
    for index in 0 .. (data.sheet_count - 1) do
      rows = Service::read_sheet(data,index)
      sheet_name = data.worksheet(index).name
      Service::import_entities(sheet_name, rows)
    end
    redirect_to reports_path()
  end

  def create
    @index = 0
    @file_name = Service::save_excel(params[:file])
    @file_path = Service::generate_file_path @file_name
    data =  Spreadsheet.open @file_path
    @rows = Service::read_sheet(data,@index)
    @sheet_list = []
    for index in 0 .. (data.sheet_count - 1) do
      @sheet_list << data.worksheet(index).name
    end
    render :show
  end

  def show
    @index = params[:index].to_i
    @file_name = params[:file_name]
    @file_path = Service::generate_file_path params[:file_name]
    data =  Spreadsheet.open @file_path
    @rows = Service::read_sheet(data,@index)
    @sheet_list = []
    for index in 0 .. (data.sheet_count - 1) do
      @sheet_list << data.worksheet(index).name
    end
  end

end
