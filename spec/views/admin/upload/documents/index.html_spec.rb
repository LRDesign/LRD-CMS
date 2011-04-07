require 'spec_helper'

describe "/admin/upload/documents/index" do
  before(:each) do
    assign(:documents, [ Factory(:document), Factory(:document) ])
  end

  it "should succeed" do
    render
  end
end

