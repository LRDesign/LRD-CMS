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

  has_attached_file :image, :styles => LRD::ImageStyles
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /image.*/
end
