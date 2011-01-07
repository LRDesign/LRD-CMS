require 'spec_helper'

describe User do
  describe "mass assignment" do
    it "should mass assign login and password" do
      user = User.new(:login => 'foo')
      user.login.should == 'foo'
    end
    it "should not mass assign crypted_password" do
      user = User.new(:crypted_password => 'foo')
      user.crypted_password.should_not == 'foo'
    end
  end

  describe "validations" do
    describe "uniqueness" do
      it "should not create two users with the same login" do
        user_1 = Factory.create(:user, :login => 'foo')
        user_2 = Factory.build(:user, :login => 'foo')
        user_2.should_not be_valid
      end
    end
  end

end
