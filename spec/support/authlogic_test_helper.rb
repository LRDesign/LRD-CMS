module AuthlogicTestHelper
  include Authlogic::TestCase
  def current_user(stubs = {})
    return nil if current_user_session.nil?
    current_user_session.user 
  end
  
  alias :current_person :current_user

  def current_user_session(stubs = {}, user_stubs = {}) 
    @current_user_session = UserSession.find
    # else  
    #   @current_user_session ||= mock_model(UserSession, {:person => current_user(user_stubs)}.merge(stubs))
    # end  
  end    

  def login_as(user)
    user = case user
           when Symbol
             User.find_by_login(user.to_s) || Factory.create(user)
           when String
             User.find_by_login(user)
           else
             user
           end
    @current_session = UserSession.create(user)
    user
  end

  def logout
    @current_user_session = nil
    UserSession.find.destroy if UserSession.find
  end               

  def authenticate(user)
    activate_authlogic
    login_as(user)
  end

  def enable_authlogic_without_login
    activate_authlogic
  end
end

module RSpec::Rails::ControllerExampleGroup
  include AuthlogicTestHelper
end

module RSpec::Rails::ViewExampleGroup
  include AuthlogicTestHelper
end

module RSpec::Rails::HelperExampleGroup
  include AuthlogicTestHelper
end
