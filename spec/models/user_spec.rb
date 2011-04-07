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

  describe "validations" do
    describe "on login" do

      it "should reject a user with no login" do
        Factory.build(:user, :login => nil).should_not be_valid
      end

      it "should allow auser with a login" do
        Factory.build(:user, :login => 'foo').should be_valid
      end
    end
  end
end
