class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = false
  end

  # REMEMBER:  attr_accessible :attr1, :attr2 
  #
  # Logical Reality Projects set attr_accessible :nil by default for all 
  # models. (see config/initializers/security_defaults.rb)  So if you don't 
  # make your attributes accessible you won't be able to mass-assign them, 
  # which can be a PITA to debug.  Please do this intelligently, and only for 
  # attributes that should be assignable from a web form.  Things like a 
  # User#admin boolean probably should not be accessible. :-)
  attr_accessible :login, :password, :password_confirmation,
                  :crypted_password, :password_salt, 
                  :perishable_token, :persistence_token, :login_count,
                  :failed_login_count, :last_request_at, :current_login_at,
                  :last_login_at, :current_login_ip, :last_login_ip
                                               
  # TODO:  create a validation or two
  # 
  # The model needs a validation for the controller specs to be completed.
  # you can use that then to set @valid_create_params and similar in
  # the generated controller specs, and make
  
end
