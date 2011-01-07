require 'spec_helper'

describe UserSessionsController do

  before(:each) do
    activate_authlogic
    @user = Factory(:user)
    @user_session = Factory(:user_session)
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
          :login => "john",
          :password => 'foobar'
        }
      end

      it "should log in the correct user" do
        post :create, :user_session => @valid_create_params
        assigns(:user_session).user.should == @user
      end
    end

    describe "with invalid params" do
      before do
        @invalid_create_params = {
          :login => "john",
          :password => nil
        }
      end

      it "should not log in anyone" do
        post :create, :user_session => @valid_create_params
        assigns(:user_session).user.should be_nil
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
      assigns(:user_session).user.should be_nil
    end
  end

end
