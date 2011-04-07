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
  describe "validations" do
    describe "on name" do

      it "should reject a location with no name" do
        Factory.build(:location, :name => nil).should_not be_valid
      end

      it "should allow alocation with a name" do
        Factory.build(:location, :name => 'foo').should be_valid
      end
    end
  end
end
