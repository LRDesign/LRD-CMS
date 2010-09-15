require 'spec_helper'

describe "/<%= table_name %>/index" do
  include <%= controller_class_name %>Helper
  
  before(:each) do
    assigns[:<%= file_name %>] = [ Factory(:<%= singular_name %>), Factory(:<%= singular_name %>) ]
  end                   

  it "should succeed" do
    render
  end
end

