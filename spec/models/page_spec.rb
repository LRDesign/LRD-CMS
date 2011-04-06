# == Schema Information
#
# Table name: pages
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  headline    :string(255)
#  permalink   :string(255)
#  content     :text
#  published   :boolean(1)      default(TRUE), not null
#  keywords    :text
#  description :text
#  edited_at   :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Page do
  pending "add some examples to (or delete) #{__FILE__}"
end
