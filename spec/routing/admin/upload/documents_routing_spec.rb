require 'spec_helper'

describe Admin::Upload::DocumentsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/upload/documents" }.should route_to(:controller => "admin/upload/documents", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/upload/documents/new" }.should route_to(:controller => "admin/upload/documents", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/upload/documents/1" }.should route_to(:controller => "admin/upload/documents", :action => "show", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/upload/documents" }.should route_to(:controller => "admin/upload/documents", :action => "create") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/upload/documents/1" }.should route_to(:controller => "admin/upload/documents", :action => "destroy", :id => "1") 
    end
  end
end
