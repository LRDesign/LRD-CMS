require 'spec_helper'

describe Admin::Upload::ImagesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/upload/images" }.should route_to(:controller => "admin/upload/images", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/upload/images/new" }.should route_to(:controller => "admin/upload/images", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/upload/images/1" }.should route_to(:controller => "admin/upload/images", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/upload/images/1/edit" }.should route_to(:controller => "admin/upload/images", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/upload/images" }.should route_to(:controller => "admin/upload/images", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/admin/upload/images/1" }.should route_to(:controller => "admin/upload/images", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/upload/images/1" }.should route_to(:controller => "admin/upload/images", :action => "destroy", :id => "1") 
    end
  end
end
