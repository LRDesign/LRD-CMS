require 'spec_helper'

describe "/admin/upload/documents/new" do
  before(:each) do
    assign(:document, Factory.build(:document))
  end

  it "should succeed" do
    render
  end


  it "should render new form" do
    render

    rendered.should have_selector("form", :action => admin_upload_documents_path, :method=> 'post')
  end
end


