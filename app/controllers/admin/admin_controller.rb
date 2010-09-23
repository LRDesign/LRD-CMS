class Admin::AdminController < ApplicationController
  before_filter :redirect_to_root_if_not_logged_in

  def redirect_to_root_if_not_logged_in
    unless logged_in?
      redirect_to :root
    end
  end
end
