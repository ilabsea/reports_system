module RequestTrackingConcern
  extend ActiveSupport::Concern

  included do
    after_action :track_previous_page
  end

  def track_previous_page
    return nil if request.xhr?

    path = request.fullpath
    if(path != login_path && path != logout_path && !request.xhr? )
      store_previous_page path
    end
  end

  def store_previous_page path
    session[:previous_page] = path
  end

  def previous_page
    session[:previous_page]
  end
  
end
