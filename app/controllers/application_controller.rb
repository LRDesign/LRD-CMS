require 'authenticated_system'

class ApplicationController < ActionController::Base
  protect_from_forgery

  include AuthenticatedSystem
end
