require 'authenticated_system'

module ApplicationHelper
  include AuthenticatedSystem

  def admin?
    logged_in?
  end

  def loc_path(loc)
    loc.page ? "/#{loc.page.permalink}" : loc.path
  end
end
