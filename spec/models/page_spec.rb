# == Schema Information
#
# Table name: pages
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  headline    :string(255)
#  permalink   :string(255)
#  content     :text
#  published   :boolean(1)      default(TRUE), not null
#  keywords    :text
#  description :text
#  edited_at   :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Page do
  describe "validations" do
    describe "on title" do
      it "should reject a page with no title" do
        Factory.build(:page, :title => nil).should_not be_valid
      end

      it "should allow a page with a title" do
        Factory.build(:page, :title => 'Foo').should be_valid
      end

      it "should reject a page with a non-unique title" do
        Factory(:page, :title => "Foo")
        Factory.build(:page, :title => 'Foo').should_not be_valid
      end

    end
  end
end
