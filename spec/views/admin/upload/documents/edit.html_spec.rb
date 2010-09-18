require 'spec_helper'

describe "/admin_upload_documents/edit" do
  include Admin::Upload::DocumentsHelper
  
  before(:each) do
    assign(:document, @document = Factory(:document) )
  end
  
  it "should succeed" do
    render
  end

  it "should render edit form" do
    render
    
    rendered.should have_selector("form", :action => document_path(@document), :method=> 'post') do |form|
    end
  end
end


