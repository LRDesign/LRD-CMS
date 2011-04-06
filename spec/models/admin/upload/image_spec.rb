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

require 'spec_helper'

describe Admin::Upload::Image do
  pending "add some examples to (or delete) #{__FILE__}"
end
