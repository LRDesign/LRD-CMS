require 'spec_helper'

describe UserSessionsController do

  before(:each) do
    @user_session = Factory(:user_session)
  end

  ########################################################################################
  #                                      GET INDEX
  ########################################################################################
  describe "GET index" do
    it "should expose all user_sessions as @user_sessions" do
      get :index
      assigns[:user_sessions].should == [@user_session]
    end
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested user_session as @user_session" do
      get :show, :id => @user_session.id
      assigns[:user_session].should == @user_session
    end  
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
  #                                      GET EDIT
  ########################################################################################
  describe "responding to GET edit" do  
    it "should expose the requested user_session as @user_session" do
      get :edit, :id => @user_session.id
      assigns[:user_session].should == @user_session
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
  #                                      PUT UPDATE
  ########################################################################################
  describe "responding to PUT update" do

    describe "with valid params" do
      before do
        pending "need definition of valid_update_params"
        @valid_update_params = {        
          # TODO: Once some model validations have been created,
          # put attributes in here that will PASS validation          
        }
      end
      
      it "should update the requested user_session in the database" do          
        lambda do
          put :update, :id => @user_session.id, :user_session => @valid_update_params
        end.should change{ @user_session.reload.attributes }
      end

      it "should expose the requested user_session as @user_session" do
        put :update, :id => @user_session.id, :user_session => @valid_update_params
        assigns(:user_session).should == @user_session
      end

      it "should redirect to the user_session" do
        put :update, :id => @user_session.id, :user_session => @valid_update_params
        response.should redirect_to(user_session_url(@user_session))
      end
    end
    
    describe "with invalid params" do
      before do
        pending "need definition of invalid_update_params"
        @invalid_update_params = {                        
          # TODO: Once some model validations have been created,
          # put attributes in here that will FAIL validation
        } 
      end
      
      it "should not change the user_session in the database" do
        lambda do 
          put :update, :id => @user_session.id, :user_session => @invalid_update_params
        end.should_not change{ @user_session.reload }
      end

      it "should expose the user_session as @user_session" do
        put :update, :id => @user_session.id, :user_session => @invalid_update_params
        assigns(:user_session).should == @user_session
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @user_session.id, :user_session => @invalid_update_params
        response.should render_template('edit')
      end
    end
  end


  ########################################################################################
  #                                      DELETE DESTROY
  ########################################################################################
  describe "DELETE destroy" do

    it "should reduce user_session count by one" do
      lambda do
        delete :destroy, :id => @user_session.id
      end.should change(UserSession, :count).by(-1)
    end
    
    it "should make the user_sessions unfindable in the database" do    
      delete :destroy, :id => @user_session.id
      lambda{ UserSession.find(@user_session.id)}.should raise_error(ActiveRecord::RecordNotFound)      
    end
  
    it "should redirect to the user_sessions list" do
      delete :destroy, :id => @user_session.id
      response.should redirect_to(user_sessions_url)
    end
  end

end
