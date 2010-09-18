class Page < ActiveRecord::Base
        

  # REMEMBER:  attr_accessible :attr1, :attr2 
  #
  # Logical Reality Projects set attr_accessible :nil by default for all 
  # models. (see config/initializers/security_defaults.rb)  So if you don't 
  # make your attributes accessible you won't be able to mass-assign them, 
  # which can be a PITA to debug.  Please do this intelligently, and only for 
  # attributes that should be assignable from a web form.  Things like a 
  # User#admin boolean probably should not be accessible. :-)
  attr_accessible :title, :permalink, :content, :edited_at
                                               
  # TODO:  create a validation or two
  # 
  # The model needs a validation for the controller specs to be completed.
  # you can use that then to set @valid_create_params and similar in
  # the generated controller specs, and make
  validates_presence_of :title, :permalink
  validates_uniqueness_of :title, :permalink
end
