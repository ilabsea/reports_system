module AuthenticableConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    
    helper_method :current_user, :user_signed_in?
  end

  def authenticate_user!
    if(!user_signed_in?)
      redirect_to login_path, notice: t('login.log_in_first')
    else
      ActiveApi.init_auth(current_user)  
    end
  end

  def sign_in auth
    session[:auth] = auth
  end

  def sign_out
    session[:auth] = nil
  end

  def user_signed_in?
    session[:auth].present?
  end

  def current_user
    session[:auth]
  end

  def after_sign_in_path
    previous_page || reports_path
  end

  def after_sign_out_path
    login_path
  end

end
