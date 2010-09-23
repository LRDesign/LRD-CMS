require 'spec_helper'

describe Admin::Upload::ImagesController do
  include ImageTestHelper

  before(:each) do
    @image = Factory(:image)
    authenticate('admin')
  end

  ########################################################################################
  #                                      GET INDEX
  ########################################################################################
  describe "GET index" do
    it "should expose all admin_upload_images as @images" do
      get :index
      assigns[:images].should == [@image]
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
  #                                      POST CREATE
  ########################################################################################
  describe "responding to POST create" do

    describe "with valid params" do
      before do
        @img = mock_proper_image(:save => true)
        Admin::Upload::Image.should_receive(:new).with({'these' => 'params'}).and_return(@img)
        post :create, :admin_upload_image => {:these => 'params'}
      end
      
      it "should create a new image and expose it" do
        assigns(:image).should equal(@img)
      end

      it "should redirect to the created image" do
        response.should redirect_to(admin_upload_image_url(@img))
      end      
    end
    
    describe "with invalid params" do
      before do
        lambda do
          @img = mock_improper_image(:save => false)
          Admin::Upload::Image.should_receive(:new).with({'these' => 'params'}).and_return(@img)
          post :create, :admin_upload_image => {:these => 'params'}
        end.should_not change(Admin::Upload::Image, :count)
      end
      
      it "should expose a newly created image as @image" do
        assigns(:image).should equal(@img) 
      end
      
      
      it "should re-render the 'new' template" do
        response.should render_template('new')
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
