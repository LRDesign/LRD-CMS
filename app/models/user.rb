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

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = false
  end

  attr_accessible :login, :password, :password_confirmation,
                  :crypted_password, :password_salt,
                  :perishable_token, :persistence_token, :login_count,
                  :failed_login_count, :last_request_at, :current_login_at,
                  :last_login_at, :current_login_ip, :last_login_ip


  validates_presence_of :login

end
