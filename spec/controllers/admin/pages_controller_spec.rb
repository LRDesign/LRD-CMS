require 'spec_helper'

describe Admin::PagesController do

  before(:each) do
    @page = Factory(:page)
  end

  ########################################################################################
  #                                      GET INDEX
  ########################################################################################
  describe "GET index" do
    it "should expose all pages as @pages" do
      get :index
      assigns[:pages].should == [@page]
    end
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested page as @page" do
      get :show, :id => @page.id
      assigns[:page].should == @page
    end  
  end

  ########################################################################################
  #                                      GET NEW
  ########################################################################################
  describe "responding to GET new" do  
    it "should expose a new page as @page" do
      get :new
      assigns[:page].should be_a(Page)
      assigns[:page].should be_new_record
    end
  end

  ########################################################################################
  #                                      GET EDIT
  ########################################################################################
  describe "responding to GET edit" do  
    it "should expose the requested page as @page" do
      get :edit, :id => @page.id
      assigns[:page].should == @page
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
      
      it "should create a new page in the database" do
        lambda do 
          post :create, :page => @valid_create_params
        end.should change(Page, :count).by(1)
      end

      it "should expose a saved page as @page" do
        post :create, :page => @valid_create_params
        assigns[:page].should be_a(Page)
      end
      
      it "should save the newly created page as @page" do
        post :create, :page => @valid_create_params
        assigns[:page].should_not be_new_record
      end

      it "should redirect to the created page" do
        post :create, :page => @valid_create_params
        new_page = assigns[:page]
        response.should redirect_to(admin_page_url(new_page))
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
      
      it "should not create a new page in the database" do
        lambda do 
          post :create, :page => @invalid_create_params
        end.should_not change(Page, :count)
      end      
      
      it "should expose a newly created page as @page" do
        post :create, :page => @invalid_create_params
        assigns(:page).should be_a(Page)
      end
      
      it "should expose an unsaved page as @page" do
        post :create, :page => @invalid_create_params
        assigns(:page).should be_new_record
      end
      
      it "should re-render the 'new' template" do
        post :create, :page => @invalid_create_params
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
      
      it "should update the requested page in the database" do          
        lambda do
          put :update, :id => @page.id, :page => @valid_update_params
        end.should change{ @page.reload.attributes }
      end

      it "should expose the requested page as @page" do
        put :update, :id => @page.id, :page => @valid_update_params
        assigns(:page).should == @page
      end

      it "should redirect to the page" do
        put :update, :id => @page.id, :page => @valid_update_params
        response.should redirect_to(admin_page_url(@page))
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
      
      it "should not change the page in the database" do
        lambda do 
          put :update, :id => @page.id, :page => @invalid_update_params
        end.should_not change{ @page.reload }
      end

      it "should expose the page as @page" do
        put :update, :id => @page.id, :page => @invalid_update_params
        assigns(:page).should == @page
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @page.id, :page => @invalid_update_params
        response.should render_template('edit')
      end
    end
  end


  ########################################################################################
  #                                      DELETE DESTROY
  ########################################################################################
  describe "DELETE destroy" do

    it "should reduce page count by one" do
      lambda do
        delete :destroy, :id => @page.id
      end.should change(Page, :count).by(-1)
    end
    
    it "should make the admin_pages unfindable in the database" do    
      delete :destroy, :id => @page.id
      lambda{ Page.find(@page.id) }.should raise_error(ActiveRecord::RecordNotFound)      
    end
  
    it "should redirect to the admin_pages list" do
      delete :destroy, :id => @page.id
      response.should redirect_to(admin_pages_url)
    end
  end

end
