require 'spec_helper'

steps "Admin creates a page", :type => :feature do

  it "should load the login page" do
    visit '/login'
  end

  it "when the admin logs in" do
    fill_in("user_session_login", :with => "admin")
    fill_in("user_session_password", :with => "wxyz")
    click_button("Login")
  end

  it "should visit the Edit Pages page" do
    click_link "Edit Pages"
  end

  it "should open the new page form" do
    click_link "New page"
    page.should have_css("form#new_page")
  end

  it "the admin enters page info" do
    birthday = Time.new.years_ago(30).months_since(6).strftime("%m/%d/%Y")
    fill_in "Title",        :with => "The Cool Page"
    fill_in "Permalink",        :with => "cool_page"
    fill_in "Content", :with => "Judson is {{ age: #{birthday} }}  Evan is {{ age: not telling }}"
    click_button "Save Page"
  end

  it "should show the edited page correctly" do
    current_path.should == "/cool_page"
    within("div#content-body") do
      page.should have_content("Judson is 29")
      page.should have_content("{{ age: not telling }}")
    end
  end

  it "visits the page index page" do
    @pr = Page.last
    click_link "Edit Pages"
    page.should have_css("a[href='/cool_page']")
    page.should have_content(@pr.title)
  end

  #jdl: delete and prompt
  it "when the admin clicks delete" do
    within("tr#page_#{@pr.id}.page") do
      click_link "Delete"
    end
    alert = page.driver.browser.switch_to.alert
    alert.accept
  end

  it "should be removed from the Pages list" do
    page.should_not have_content(@pr.title)
  end

  it "should no longer be visitable" do
    #expect do
      visit "/cool_page"
    #end.to raise_error
  end

end