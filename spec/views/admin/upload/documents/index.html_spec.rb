require 'spec_helper'

describe "/admin_upload_documents/index" do
  include Admin::Upload::DocumentsHelper
  
  before(:each) do 
    assign(:documents, [ Factory(:document), Factory(:document) ])
  end                   

  it "should succeed" do
    render
  end
end

