require 'spec_helper'

describe Admin::Upload::Document do
   describe "validations" do
     describe "presence" do
       it "should not validate a document without attachment values" do
         Factory.build(:document,
           :data_file_name => nil,
           :data_file_size => nil,
           :data_content_type => nil
         ).should_not be_valid
       end
       it "should validate a document with attachment values" do
         Factory.build(:document,
           :data_file_name => 'dummy',
           :data_file_size => 1,
           :data_content_type => 'fake/fake'
         ).should be_valid
       end
     end
   end
end
