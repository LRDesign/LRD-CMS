require 'spec_helper'

describe Admin::LocationsController do

  describe "logged in as admin" do
    before(:each) do
      @location = Factory(:location)
      authenticate('admin')
    end

    ########################################################################################
    #                                      GET INDEX
    ########################################################################################
    describe "GET index" do
      it "should expose all locations as @locations" do
        get :index
        assigns[:locations].should == [@location]
      end
    end

    ########################################################################################
    #                                      GET SHOW
    ########################################################################################
    describe "responding to GET show" do
      it "should expose the requested location as @location" do
        get :show, :id => @location.id
        assigns[:location].should == @location
      end  
    end

    ########################################################################################
    #                                      GET NEW
    ########################################################################################
    describe "responding to GET new" do  
      it "should expose a new location as @location" do
        get :new
        assigns[:location].should be_a(Location)
        assigns[:location].should be_new_record
      end
    end

    ########################################################################################
    #                                      GET EDIT
    ########################################################################################
    describe "responding to GET edit" do  
      it "should expose the requested location as @location" do
        get :edit, :id => @location.id
        assigns[:location].should == @location
      end
    end

    ########################################################################################
    #                                      POST CREATE
    ########################################################################################
    describe "responding to POST create" do

      describe "with valid params" do
        before do
          @valid_create_params = { 
            :name => "Location One",
            :path => 'location/1'
          }
        end
        
        it "should create a new location in the database" do
          lambda do 
            post :create, :location => @valid_create_params
          end.should change(Location, :count).by(1)
        end

        it "should expose a saved location as @location" do
          post :create, :location => @valid_create_params
          assigns[:location].should be_a(Location)
        end
        
        it "should save the newly created location as @location" do
          post :create, :location => @valid_create_params
          assigns[:location].should_not be_new_record
        end

        it "should redirect to the created location" do
          post :create, :location => @valid_create_params
          new_location = assigns[:location]
          response.should redirect_to(admin_location_url(new_location))
        end      
      end
      
      describe "with invalid params" do
        before do
          @invalid_create_params = {    
            :name => nil,
            :path => 'location/1'
          } 
        end
        
        it "should not create a new location in the database" do
          lambda do 
            post :create, :location => @invalid_create_params
          end.should_not change(Location, :count)
        end      
        
        it "should expose a newly created location as @location" do
          post :create, :location => @invalid_create_params
          assigns(:location).should be_a(Location)
        end
        
        it "should expose an unsaved location as @location" do
          post :create, :location => @invalid_create_params
          assigns(:location).should be_new_record
        end
        
        it "should re-render the 'new' template" do
          post :create, :location => @invalid_create_params
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
        
        it "should update the requested location in the database" do          
          lambda do
            put :update, :id => @location.id, :location => @valid_update_params
          end.should change{ @location.reload.attributes }
        end

        it "should expose the requested location as @location" do
          put :update, :id => @location.id, :location => @valid_update_params
          assigns(:location).should == @location
        end

        it "should redirect to the location" do
          put :update, :id => @location.id, :location => @valid_update_params
          response.should redirect_to(admin_location_url(@location))
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
        
        it "should not change the location in the database" do
          lambda do 
            put :update, :id => @location.id, :location => @invalid_update_params
          end.should_not change{ @location.reload }
        end

        it "should expose the location as @location" do
          put :update, :id => @location.id, :location => @invalid_update_params
          assigns(:location).should == @location
        end

        it "should re-render the 'edit' template" do
          put :update, :id => @location.id, :location => @invalid_update_params
          response.should render_template('edit')
        end
      end
    end


    ########################################################################################
    #                                      DELETE DESTROY
    ########################################################################################
    describe "DELETE destroy" do

      it "should reduce location count by one" do
        lambda do
          delete :destroy, :id => @location.id
        end.should change(Location, :count).by(-1)
      end
      
      it "should make the locations unfindable in the database" do    
        delete :destroy, :id => @location.id
        lambda{ Location.find(@location.id)}.should raise_error(ActiveRecord::RecordNotFound)      
      end
    
      it "should redirect to the locations list" do
        delete :destroy, :id => @location.id
        response.should redirect_to(admin_locations_url)
      end
    end
  end

end
