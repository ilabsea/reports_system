class ApplicationController < ActionController::Base
  include AuthenticableConcern
  include RequestTrackingConcern

  protect_from_forgery with: :exception

end
