require 'spec_helper'

describe Location do
  describe "mass assignment" do
     it "should mass assign name and path" do
       location = Location.new(:name => 'foo', :path => 'bar' )
       location.name.should == 'foo'
       location.path.should == 'bar'
     end
   end

   describe "validations" do
     describe "presence" do
       it "should not create a location with blank name" do
         Factory.build(:location, :name => nil).should_not be_valid
       end
     end
   end
end
