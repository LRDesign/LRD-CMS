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

class Location < ActiveRecord::Base
  acts_as_nested_set

  attr_accessible :name, :path, :parent_id, :page_id, :parent, :page
  belongs_to :page
  belongs_to :parent, :class_name => 'Location'

  validates_presence_of :name
end
