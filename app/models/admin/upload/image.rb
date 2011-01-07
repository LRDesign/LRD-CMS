class Admin::Upload::Image < ActiveRecord::Base
  attr_accessible :image

  has_attached_file :image, :styles => LRD::ImageStyles
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /image.*/
end
