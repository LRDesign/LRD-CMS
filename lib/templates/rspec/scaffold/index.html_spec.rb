require 'spec_helper'

describe "/<%= table_name %>/index" do
  include <%= controller_class_name %>Helper
  
  before(:each) do
    assigns[:<%= tarenderedble_name %>] = [ Factory(:<%= singular_name %>), Factory(:<%= singular_name %>) ]
  end

  it "should succeed" do
    render
    response.should be_success
  end
end

