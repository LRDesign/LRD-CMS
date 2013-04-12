require 'spec_helper'

describe UserSessionsController do

  before(:each) do
    activate_authlogic
    @user = FactoryGirl.create(:user)
    @user_session = FactoryGirl.create(:user_session)
    @user = FactoryGirl.create(:user,
      :password => 'password',
      :password_confirmation => 'password'
    )
    logout
  end

  ########################################################################################
  #                                      GET NEW
  ########################################################################################
  describe "responding to GET new" do
    it "should expose a new user_session as @user_session" do
      get :new
      assigns[:user_session].should be_a(UserSession)
      assigns[:user_session].should be_new_record
    end
  end

  ########################################################################################
  #                                      POST CREATE
  ########################################################################################
  describe "responding to POST create" do
    describe "with valid params" do
      before do
        @valid_create_params = {
          :login    => @user.login,
          :password => 'password'
        }
      end

      it "should log in the user" do
        post :create, :user_session => @valid_create_params
        assigns[:user_session].should be_a(UserSession)
        controller.current_user.should == @user
      end
    end

    describe "with invalid params" do
      before do
        @invalid_create_params = {
          :login    => @user.login,
          :password => 'password1'
        }
      end

      it "should not log in the user" do
        post :create, :user_session => @valid_create_params
        controller.current_user.should be_nil
      end
    end
  end

  ########################################################################################
  #                                      DELETE DESTROY
  ########################################################################################
  describe "DELETE destroy" do
    before do
      login_as @user
    end

    it "should log the user out" do
      delete :destroy
      controller.current_user.should be_nil
    end


  end

end
