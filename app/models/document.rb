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

class Document < ActiveRecord::Base

  attr_accessible :data

  has_attached_file :data
  validates_attachment_presence :data
end
