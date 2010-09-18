require 'spec_helper'

describe Admin::Upload::DocumentsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin_upload_documents" }.should route_to(:controller => "admin_upload_documents", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin_upload_documents/new" }.should route_to(:controller => "admin_upload_documents", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin_upload_documents/1" }.should route_to(:controller => "admin_upload_documents", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin_upload_documents/1/edit" }.should route_to(:controller => "admin_upload_documents", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin_upload_documents" }.should route_to(:controller => "admin_upload_documents", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/admin_upload_documents/1" }.should route_to(:controller => "admin_upload_documents", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin_upload_documents/1" }.should route_to(:controller => "admin_upload_documents", :action => "destroy", :id => "1") 
    end
  end
end
