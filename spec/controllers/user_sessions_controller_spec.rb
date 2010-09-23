require 'spec_helper'

describe UserSessionsController do

  before(:each) do
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
        pending "need definition of valid_create_params"
        @valid_create_params = { 
          # TODO: Once some model validations have been created,
          # put attributes in here that will PASS validation                    
        }
      end
      
      it "should create a new user_session in the database" do
        lambda do 
          post :create, :user_session => @valid_create_params
        end.should change(UserSession, :count).by(1)
      end

      it "should expose a saved user_session as @user_session" do
        post :create, :user_session => @valid_create_params
        assigns[:user_session].should be_a(UserSession)
      end
      
      it "should save the newly created user_session as @user_session" do
        post :create, :user_session => @valid_create_params
        assigns[:user_session].should_not be_new_record
      end

      it "should redirect to the created user_session" do
        post :create, :user_session => @valid_create_params
        new_user_session = assigns[:user_session]
        response.should redirect_to(user_session_url(new_user_session))
      end      
    end
    
    describe "with invalid params" do
      before do
        pending "need definition of invalid_create_params"
        @invalid_create_params = {    
          # TODO: Once some model validations have been created,
          # put attributes in here that will FAIL validation          
        } 
      end
      
      it "should not create a new user_session in the database" do
        lambda do 
          post :create, :user_session => @invalid_create_params
        end.should_not change(UserSession, :count)
      end      
      
      it "should expose a newly created user_session as @user_session" do
        post :create, :user_session => @invalid_create_params
        assigns(:user_session).should be_a(UserSession)
      end
      
      it "should expose an unsaved user_session as @user_session" do
        post :create, :user_session => @invalid_create_params
        assigns(:user_session).should be_new_record
      end
      
      it "should re-render the 'new' template" do
        post :create, :user_session => @invalid_create_params
        response.should render_template('new')
      end      
    end    
  end

  ########################################################################################
  #                                      DELETE DESTROY
  ########################################################################################
  describe "DELETE destroy" do

  end

end
