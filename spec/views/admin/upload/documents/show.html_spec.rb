require 'spec_helper'

describe "/admin/upload/documents/show" do
  include Admin::Upload::DocumentsHelper
  
  before(:each) do    
    assign(:document, @document = Factory(:document))
  end

  it "should succeed" do
    render
  end
end

