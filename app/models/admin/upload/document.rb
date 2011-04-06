# == Schema Information
#
# Table name: admin_upload_documents
#
#  id                :integer(4)      not null, primary key
#  data_file_name    :string(255)
#  data_file_size    :integer(4)
#  data_content_type :string(255)
#  data_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Admin::Upload::Document < ActiveRecord::Base
        

  # REMEMBER:  attr_accessible :attr1, :attr2 
  #
  # Logical Reality Projects set attr_accessible :nil by default for all 
  # models. (see config/initializers/security_defaults.rb)  So if you don't 
  # make your attributes accessible you won't be able to mass-assign them, 
  # which can be a PITA to debug.  Please do this intelligently, and only for 
  # attributes that should be assignable from a web form.  Things like a 
  # User#admin boolean probably should not be accessible. :-)
                                               
  attr_accessible :data

  has_attached_file :data
  validates_attachment_presence :data
end
