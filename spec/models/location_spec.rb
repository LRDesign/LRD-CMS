# == Schema Information
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  path       :string(255)
#  parent_id  :integer(4)
#  lft        :integer(4)
#  rgt        :integer(4)
#  page_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Location do
  pending "add some examples to (or delete) #{__FILE__}"
end
