require 'spec_helper'

describe "/pages/show" do
  before(:each) do
    activate_authlogic
    assign(:page, @page = Factory(:page))
    view.stub!(:params).and_return( :controller => 'pages', :action => 'show' )
  end

  it "should succeed" do
    render
  end

  it "should interpolate css at the top of the page" do
    assign(:page, @page = Factory(:page, :css => 'body { color: green; }'))
    render :template => 'pages/show', :layout => 'layouts/application'
    rendered.should have_selector('style') do |scope|
      scope.should contain(/body \{ color: green; \}/)
    end
  end

  it "should interpolate keywords at the top of the page" do
    assign(:page, @page = Factory(:page, :keywords => 'foo, bar'))
    render :template => 'pages/show', :layout => 'layouts/application'
    rendered.should have_selector('head') do |scope|
      scope.should have_selector("meta[name='keywords'][content='foo, bar']")
    end
  end

  it "should interpolate description at the top of the page" do
    assign(:page, @page = Factory(:page, :description => 'A foo page'))
    render :template => 'pages/show', :layout => 'layouts/application'
    rendered.should have_selector('head') do |scope|
      scope.should have_selector("meta[name='description'][content='A foo page']")
    end
  end

end
