require 'spec_helper'

describe Admin::Upload::ImagesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin_upload_images" }.should route_to(:controller => "admin_upload_images", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin_upload_images/new" }.should route_to(:controller => "admin_upload_images", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin_upload_images/1" }.should route_to(:controller => "admin_upload_images", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin_upload_images/1/edit" }.should route_to(:controller => "admin_upload_images", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin_upload_images" }.should route_to(:controller => "admin_upload_images", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/admin_upload_images/1" }.should route_to(:controller => "admin_upload_images", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin_upload_images/1" }.should route_to(:controller => "admin_upload_images", :action => "destroy", :id => "1") 
    end
  end
end
