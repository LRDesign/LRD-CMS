require 'spec_helper'
include TinyMCETools

steps "Admin creates a menu", :type => :feature, :js => true do

  it "should load the login page" do
    visit '/login'
  end

  it "when the admin logs in" do
    fill_in("user_login", :with => "admin")
    fill_in("user_password", :with => "wxyz")
    click_button("Login")
  end

  it "and creates two pages" do
    click_link "Edit Pages"
    click_link "New page"
    fill_in "Title",        :with => "The Cool Page"
    fill_in "Permalink",        :with => "cool_page"
    fill_in_tinymce "page_content", :with => "Judson is 29 and Evan is not telling"
    click_button "Save Page"
    click_link "Edit Pages"
    click_link "New page"
    fill_in "Title",        :with => "The Dumb Page"
    fill_in "Permalink",        :with => "dumb_page"
    fill_in_tinymce "page_content", :with => "How should I know how old these people are?"
    click_button "Save Page"
  end

  it "should visit the Edit Menu page" do
    click_link "Edit Menu"
  end

  it "should open the new menu item form" do
    click_link "New Menu Entry"
    page.should have_css("form#new_location")
  end

  it "admin enters a root menu item" do
    fill_in "Name", :with => "home"
    fill_in "Path", :with => "/"
    click_button "Save Menu Entry"
  end

  it "should show a menu item was created" do
    page.should have_content("Menu Entry was successfully created.")
    page.should have_content("home")
    page.should have_content("/")
  end

  it "should open the new menu item form" do
    click_link "New Menu Entry"
    page.should have_css("form#new_location")
  end

  it "admin enters a menu item for first page" do
    fill_in "Name", :with => "Coolness"
    select "The Cool Page", :from => "Page"
    select "home", :from => "Parent"
    click_button "Save Menu Entry"
  end

  it "should show the menu item was created" do
    page.should have_content("Menu Entry was successfully created.")
    page.should have_content("Coolness")
    page.should have_content("The Cool Page")
    @cool_menu = Location.last
  end

  it "should open the new menu item form" do
    click_link "New Menu Entry"
    page.should have_css("form#new_location")
  end

  it "admin enters a menu item for the second page" do
    fill_in "Name", :with => "Just stupid"
    select "The Dumb Page", :from => "Page"
    select "home", :from => "Parent"
    click_button "Save Menu Entry"
  end

  it "should show the menu item was created" do
    page.should have_content("Menu Entry was successfully created.")
    page.should have_content("Just stupid")
    page.should have_content("The Dumb Page")
    @dumb_menu = Location.last
  end

  it "admin visits the site homepage" do
    visit "/"
  end

  it "should show the menu" do
    within "div#nav" do
      within "ul#nav_menu" do
        within "li#location_#{@cool_menu.id}" do
          page.should have_css("a[href='/cool_page']")
          page.should have_content("Coolness")
        end
        within "li#location_#{@dumb_menu.id}" do
          page.should have_css("a[href='/dumb_page']")
          page.should have_content("Just stupid")
        end
      end
    end
  end

  it "should visit the Edit Menu page" do
    click_link "Edit Menu"
    page.should have_css("a[href='/cool_page']")
    page.should have_content(@cool_menu.name)
  end

  it "when the admin clicks edit" do
    within("tr#location_#{@cool_menu.id}") do
      click_link "Edit"
    end
    page.should have_css("form#edit_location_#{@cool_menu.id}")
  end

  it "and changes the order of menu items" do
    select "Last", :from => "Move to"
    click_button "Save Menu Entry"
  end

  it "and goes back to the site homepage" do
    visit "/"
  end

  it "should show the menu in the new order" do
    within "div#nav" do
      within "ul#nav_menu" do
        page.should have_css("li:nth-child(1)#location_#{@dumb_menu.id}")
        page.should have_css("li:nth-child(2)#location_#{@cool_menu.id}")
      end
    end
  end

end
