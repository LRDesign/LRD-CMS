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

require 'spec_helper'

describe Admin::Upload::Document do
  pending "add some examples to (or delete) #{__FILE__}"
end
