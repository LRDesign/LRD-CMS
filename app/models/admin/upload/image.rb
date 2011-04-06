# == Schema Information
#
# Table name: admin_upload_images
#
#  id                 :integer(4)      not null, primary key
#  image_file_name    :string(255)
#  image_file_size    :integer(4)
#  image_content_type :string(255)
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class Admin::Upload::Image < ActiveRecord::Base
        

  # REMEMBER:  attr_accessible :attr1, :attr2 
  #
  # Logical Reality Projects set attr_accessible :nil by default for all 
  # models. (see config/initializers/security_defaults.rb)  So if you don't 
  # make your attributes accessible you won't be able to mass-assign them, 
  # which can be a PITA to debug.  Please do this intelligently, and only for 
  # attributes that should be assignable from a web form.  Things like a 
  # User#admin boolean probably should not be accessible. :-)
  attr_accessible :image

  has_attached_file :image, :styles => LRD::ImageStyles
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /image.*/
end
