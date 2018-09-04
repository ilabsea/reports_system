class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to reports_path()
    else
      render :layout => 'login'
    end
  end
  
  def create
    begin
      response = User::request_verboice_authentication(params[:email], params[:password])
      if(response["success"])
        session["auth_token"] = response["auth_token"]
        session["email"] = response["email"]
        redirect_to reports_path()
      else
        redirect_to root_url, error: "User or password is incorrect!"
      end
    rescue
      redirect_to root_url, error: "Failed to connect to verboice!"
    end
  end
  
  def destroy
    session["auth_token"] = nil
    session["email"] = nil
    redirect_to root_url, notice: 'Logged out!'
  end

  private 

  def current_user
    return false if session["email"].to_s.empty? or session["auth_token"].to_s.empty?
    return true
  end
end
