class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = false
  end

  attr_accessible :login, :password, :password_confirmation,
                  :login_count, :failed_login_count, :last_request_at, :current_login_at,
                  :last_login_at, :current_login_ip, :last_login_ip
end
