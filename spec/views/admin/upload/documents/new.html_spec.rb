require 'spec_helper'

describe "/admin_upload_documents/new" do
  include Admin::Upload::DocumentsHelper
  
  before(:each) do    
    assign(:document, Factory.build(:document))
  end
  
  it "should succeed" do
    render
  end
  

  it "should render new form" do
    render
                                          
    rendered.should have_selector("form", :action => admin_upload_documents_path, :method=> 'post') do |form|   
      
    end
  end
end


