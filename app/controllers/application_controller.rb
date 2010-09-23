require 'authenticated_system'

class ApplicationController < ActionController::Base
  protect_from_forgery

  include AuthenticatedSystem  
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
end
