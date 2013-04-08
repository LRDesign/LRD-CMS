require 'authenticated_system'

module ApplicationHelper
  include AuthenticatedSystem

  def admin?
    logged_in?
  end

  def loc_path(loc)
    loc.page ? "/#{loc.page.permalink}" : loc.path
  end

  def body_class
    klasses = params[:controller].split("/")
    klasses << params[:action]
    klasses << 'with_admin' if admin?
    klasses << @body_classes if @body_classes
    klasses
  end

  def add_body_class(klass)
    if @body_classes
      @body_classes << klass
    else
      @body_classes = [klass]
    end
  end
end
