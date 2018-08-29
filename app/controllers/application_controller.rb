class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  

  def authenticated_api_user
  	head 403 unless session["auth_token"] and session["email"]
  end

end
