require 'spec_helper'

describe Admin::Upload::Image do
  describe "validations" do
    describe "presence" do
      it "should not validate a image without attachment values" do
        Factory.build(:image,
          :image_file_name => nil,
          :image_file_size => nil,
          :image_content_type => nil
        ).should_not be_valid
      end
      it "should validate a image with attachment values" do
        Factory.build(:image,
          :image_file_name => 'dummy',
          :image_file_size => 1,
          :image_content_type => 'image/fake'
        ).should be_valid
      end
    end
  end
end
