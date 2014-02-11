require 'spec_helper'

steps "Admin manages blog posts", :type => :feature, :js => true do
  include TinyMCETools

  it "should load the login page" do
    visit '/login'
  end

  it "when the admin logs in" do
    fill_in("user_login", :with => "admin")
    fill_in("user_password", :with => "wxyz")
    click_button("Login")
  end

  it "should visit the Edit Blogs page" do
    click_link "Edit Blog Posts"
  end

  it "should create a new blog post" do
    click_link "New Blog Post"
  end

  it "should fill in some content and select a topic" do
    fill_in "Title",        :with => "A New Blog Post"
    fill_in "Permalink",        :with => "first_post"
    fill_in_tinymce "page_content", :with => "Judson is 29 and Evan is not telling"
    select "Bookkeeping", :from => "Topic"
    click_button "Save Page"
  end

  it "should visit the post" do
    visit root_path
    within "#blog" do
      click_link "A New Blog Post"
    end
  end

  it "should have the content" do
    page.should have_content "Judson is 29"
  end

  it "should visit the blogs section" do
    visit root_path
    within("#blog") do
      click_link "Read More..."
    end
  end

  it "should find the content in the blogs list" do
    page.should have_content "Judson is 29"
  end

  it "should visit the topic" do
    click_link "Bookkeeping"
  end

  it "should see the blog post under that topic" do
    page.should have_content "Judson is 29"
  end

  it "should proceed to the post" do
    click_link "Full text..."
    page.should have_content "Judson is 29"
  end

  it "should return to the Edit Blogs tool" do
    click_link "Edit Blog Posts"

    within(:xpath, "//tr[.//a[@href='/first_post']]") do
      click_link "Edit"
    end
  end

  it "should change the blog topic" do

    select "Recordkeeping", :from => "Topic"
    click_button "Save Page"
  end

  it "in the blogs section" do
    visit root_path
    within("#blog") do
      click_link "Read More..."
    end
  end

  it "should visit the old topic" do
    click_link "Bookkeeping"
  end

  it "should not see the blog post" do
    page.should_not have_content "Judson is 29"
  end

  it "from the blogs section" do
    visit root_path
    within("#blog") do
      click_link "Read More..."
    end
  end

  it "should visit the new topic" do
    click_link "Recordkeeping"
  end

  it "should see the blog post there" do
    page.should have_content "Judson is 29"
  end
end
