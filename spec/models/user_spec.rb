# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(20)      not null
#  email               :string(255)
#  first_name          :string(60)
#  last_name           :string(60)
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe User do
  describe "mass assignment" do
    it "should mass assign login" do
      user = User.new(:login => 'foo')
      user.login.should == 'foo'
    end
    it "should not mass assign crypted_password" do
      user = User.new(:encrypted_password => 'foo')
      user.encrypted_password.should_not == 'foo'
    end
  end

  describe "validations" do
    describe "uniqueness" do
      it "should not create two users with the same login" do
        user_1 = FactoryGirl.create(:user, :login => 'foo')
        user_2 = FactoryGirl.build(:user, :login => 'foo')
        user_2.should_not be_valid
      end
    end
  end

end
