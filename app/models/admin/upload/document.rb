class Admin::Upload::Document < ActiveRecord::Base

  attr_accessible :data

  has_attached_file :data
  validates_attachment_presence :data
end
