module ApplicationHelper    
  include AuthenticatedSystem
  
  def admin?
    logged_in?
  end
end
