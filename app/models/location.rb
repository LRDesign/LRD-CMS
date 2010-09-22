class Location < ActiveRecord::Base
  # REMEMBER:  attr_accessible :attr1, :attr2 
  #
  # Logical Reality Projects set attr_accessible :nil by default for all 
  # models. (see config/initializers/security_defaults.rb)  So if you don't 
  # make your attributes accessible you won't be able to mass-assign them, 
  # which can be a PITA to debug.  Please do this intelligently, and only for 
  # attributes that should be assignable from a web form.  Things like a 
  # User#admin boolean probably should not be accessible. :-)
  attr_accessible :name, :path, :parent_id, :page_id                                               
  belongs_to :page
  belongs_to :parent, :class_name => 'Location'

  validates_presence_of :name
end
