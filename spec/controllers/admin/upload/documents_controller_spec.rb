require 'spec_helper'

describe Admin::Upload::DocumentsController do

  before(:each) do
    @document = Factory(:document)
  end

  ########################################################################################
  #                                      GET INDEX
  ########################################################################################
  describe "GET index" do
    it "should expose all admin_upload_documents as @admin_upload_documents" do
      get :index
      assigns[:admin_upload_documents].should == [@document]
    end
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested document as @document" do
      get :show, :id => @document.id
      assigns[:document].should == @document
    end  
  end

  ########################################################################################
  #                                      GET NEW
  ########################################################################################
  describe "responding to GET new" do  
    it "should expose a new document as @document" do
      get :new
      assigns[:document].should be_a(Admin::Upload::Document)
      assigns[:document].should be_new_record
    end
  end

  ########################################################################################
  #                                      GET EDIT
  ########################################################################################
  describe "responding to GET edit" do  
    it "should expose the requested document as @document" do
      get :edit, :id => @document.id
      assigns[:document].should == @document
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
      
      it "should create a new document in the database" do
        lambda do 
          post :create, :document => @valid_create_params
        end.should change(Admin::Upload::Document, :count).by(1)
      end

      it "should expose a saved document as @document" do
        post :create, :document => @valid_create_params
        assigns[:document].should be_a(Admin::Upload::Document)
      end
      
      it "should save the newly created document as @document" do
        post :create, :document => @valid_create_params
        assigns[:document].should_not be_new_record
      end

      it "should redirect to the created document" do
        post :create, :document => @valid_create_params
        new_document = assigns[:document]
        response.should redirect_to(admin_upload_document_url(new_document))
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
      
      it "should not create a new document in the database" do
        lambda do 
          post :create, :document => @invalid_create_params
        end.should_not change(Admin::Upload::Document, :count)
      end      
      
      it "should expose a newly created document as @document" do
        post :create, :document => @invalid_create_params
        assigns(:document).should be_a(Admin::Upload::Document)
      end
      
      it "should expose an unsaved document as @document" do
        post :create, :document => @invalid_create_params
        assigns(:document).should be_new_record
      end
      
      it "should re-render the 'new' template" do
        post :create, :document => @invalid_create_params
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
      
      it "should update the requested document in the database" do          
        lambda do
          put :update, :id => @document.id, :document => @valid_update_params
        end.should change{ @document.reload.attributes }
      end

      it "should expose the requested document as @document" do
        put :update, :id => @document.id, :document => @valid_update_params
        assigns(:document).should == @document
      end

      it "should redirect to the document" do
        put :update, :id => @document.id, :document => @valid_update_params
        response.should redirect_to(admin_upload_document_url(@document))
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
      
      it "should not change the document in the database" do
        lambda do 
          put :update, :id => @document.id, :document => @invalid_update_params
        end.should_not change{ @document.reload }
      end

      it "should expose the document as @document" do
        put :update, :id => @document.id, :document => @invalid_update_params
        assigns(:document).should == @document
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @document.id, :document => @invalid_update_params
        response.should render_template('edit')
      end
    end
  end


  ########################################################################################
  #                                      DELETE DESTROY
  ########################################################################################
  describe "DELETE destroy" do

    it "should reduce document count by one" do
      lambda do
        delete :destroy, :id => @document.id
      end.should change(Admin::Upload::Document, :count).by(-1)
    end
    
    it "should make the admin_upload_documents unfindable in the database" do    
      delete :destroy, :id => @document.id
      lambda{ Admin::Upload::Document.find(@document.id)}.should raise_error(ActiveRecord::RecordNotFound)      
    end
  
    it "should redirect to the admin_upload_documents list" do
      delete :destroy, :id => @document.id
      response.should redirect_to(admin_upload_documents_url)
    end
  end

end
