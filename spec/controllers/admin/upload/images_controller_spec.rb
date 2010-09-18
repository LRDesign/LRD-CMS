require 'spec_helper'

describe Admin::Upload::ImagesController do

  before(:each) do
    @image = Factory(:image)
  end

  ########################################################################################
  #                                      GET INDEX
  ########################################################################################
  describe "GET index" do
    it "should expose all admin_upload_images as @admin_upload_images" do
      get :index
      assigns[:admin_upload_images].should == [@image]
    end
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested image as @image" do
      get :show, :id => @image.id
      assigns[:image].should == @image
    end  
  end

  ########################################################################################
  #                                      GET NEW
  ########################################################################################
  describe "responding to GET new" do  
    it "should expose a new image as @image" do
      get :new
      assigns[:image].should be_a(Admin::Upload::Image)
      assigns[:image].should be_new_record
    end
  end

  ########################################################################################
  #                                      GET EDIT
  ########################################################################################
  describe "responding to GET edit" do  
    it "should expose the requested image as @image" do
      get :edit, :id => @image.id
      assigns[:image].should == @image
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
      
      it "should create a new image in the database" do
        lambda do 
          post :create, :image => @valid_create_params
        end.should change(Admin::Upload::Image, :count).by(1)
      end

      it "should expose a saved image as @image" do
        post :create, :image => @valid_create_params
        assigns[:image].should be_a(Admin::Upload::Image)
      end
      
      it "should save the newly created image as @image" do
        post :create, :image => @valid_create_params
        assigns[:image].should_not be_new_record
      end

      it "should redirect to the created image" do
        post :create, :image => @valid_create_params
        new_image = assigns[:image]
        response.should redirect_to(admin_upload_image_url(new_image))
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
      
      it "should not create a new image in the database" do
        lambda do 
          post :create, :image => @invalid_create_params
        end.should_not change(Admin::Upload::Image, :count)
      end      
      
      it "should expose a newly created image as @image" do
        post :create, :image => @invalid_create_params
        assigns(:image).should be_a(Admin::Upload::Image)
      end
      
      it "should expose an unsaved image as @image" do
        post :create, :image => @invalid_create_params
        assigns(:image).should be_new_record
      end
      
      it "should re-render the 'new' template" do
        post :create, :image => @invalid_create_params
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
      
      it "should update the requested image in the database" do          
        lambda do
          put :update, :id => @image.id, :image => @valid_update_params
        end.should change{ @image.reload.attributes }
      end

      it "should expose the requested image as @image" do
        put :update, :id => @image.id, :image => @valid_update_params
        assigns(:image).should == @image
      end

      it "should redirect to the image" do
        put :update, :id => @image.id, :image => @valid_update_params
        response.should redirect_to(admin_upload_image_url(@image))
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
      
      it "should not change the image in the database" do
        lambda do 
          put :update, :id => @image.id, :image => @invalid_update_params
        end.should_not change{ @image.reload }
      end

      it "should expose the image as @image" do
        put :update, :id => @image.id, :image => @invalid_update_params
        assigns(:image).should == @image
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @image.id, :image => @invalid_update_params
        response.should render_template('edit')
      end
    end
  end


  ########################################################################################
  #                                      DELETE DESTROY
  ########################################################################################
  describe "DELETE destroy" do

    it "should reduce image count by one" do
      lambda do
        delete :destroy, :id => @image.id
      end.should change(Admin::Upload::Image, :count).by(-1)
    end
    
    it "should make the admin_upload_images unfindable in the database" do    
      delete :destroy, :id => @image.id
      lambda{ Admin::Upload::Image.find(@image.id)}.should raise_error(ActiveRecord::RecordNotFound)      
    end
  
    it "should redirect to the admin_upload_images list" do
      delete :destroy, :id => @image.id
      response.should redirect_to(admin_upload_images_url)
    end
  end

end
