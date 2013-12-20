require 'capybara/rspec'
#require 'selenium-webdriver'
require 'capybara/poltergeist'
require 'rspec-steps'

Capybara.register_driver(:selenium_chrome) do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
end

Capybara.javascript_driver = :poltergeist

module CKEditorTools
  def fill_in_ckeditor(id, options = {})
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    raise "CKEeditor fill-in only works with Selenium driver" unless page.driver.class == Capybara::Selenium::Driver
    browser = page.driver.browser
    browser.execute_script("CKEDITOR.instances['#{id}'].setData('#{options[:with]}');")
  end
end

module TinyMCETools
  def fill_in_tinymce(id, options = {})
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    raise "tiny MCE fill-in only works with Selenium driver" unless page.driver.class == Capybara::Selenium::Driver

    browser = page.driver.browser
    browser.execute_script("tinymce.getInstanceById('#{id}').setContent('#{options[:with]}')")
  end
end
