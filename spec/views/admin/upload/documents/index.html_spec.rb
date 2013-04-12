require 'spec_helper'

describe "/admin/upload/documents/index" do
  before(:each) do
    assign(:documents, [ FactoryGirl.build(:document), FactoryGirl.build(:document) ])
  end

  it "should succeed" do
    render
  end
end

