class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    if user_signed_in?
      redirect_to after_sign_in_path, notice: t('login.already_logged_in')
    else
      render :layout => 'login'
    end
  end

  def create
    auth = Session.login(params[:email], params[:password])
    if(Session.success?)
      sign_in(auth)
      redirect_to reports_path
    else
      redirect_to login_path, notice: t('login.incorrect')
    end
  end
  
  def destroy
    sign_out
    redirect_to login_path, notice: t('login.logged_out!')
  end

  private

  def protected_params
    params.permit(:email, :password)
  end

end
