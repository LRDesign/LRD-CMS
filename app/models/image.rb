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

class Image < ActiveRecord::Base

  attr_accessible :image

  mount_uploader :image, ImageUploader, :mount_on => :image_file_name
  validates_integrity_of :image
end
