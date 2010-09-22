require 'spec_helper'

describe "/user_sessions/new" do
  include UserSessionsHelper
  
  before(:each) do    
    assign(:user_session, Factory.build(:user_session))
  end
  
  it "should succeed" do
    render
  end
  

  it "should render new form" do
    render
                                          
    rendered.should have_selector("form", :action => user_sessions_path, :method=> 'post') do |form|   
      
    end
  end
end


