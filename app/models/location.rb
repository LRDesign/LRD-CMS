class Location < ActiveRecord::Base
  acts_as_nested_set

  attr_accessible :name, :path, :parent_id, :page_id, :parent, :page
  belongs_to :page
  belongs_to :parent, :class_name => 'Location'

  validates_presence_of :name#, :path
end
