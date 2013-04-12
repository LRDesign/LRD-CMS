require 'spec_helper'

describe "/user_sessions/new" do

  before(:each) do
    enable_authlogic_without_login
    assign(:user_session, FactoryGirl.build(:user_session))
  end

  it "should succeed" do
    render
  end


  it "should render new form" do
    render

    rendered.should have_selector("form", :action => user_session_path, :method=> 'post')
  end
end


