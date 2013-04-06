require 'capybara/rspec'
require 'selenium-webdriver'
require 'rspec-steps'

Capybara.register_driver(:selenium_chrome) do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.default_driver = :selenium

=begin
module SaveAndOpenOnFail
  def instance_eval(&block)
    super(&block)
  rescue Object => ex
    wrapper = ex.exception("#{ex.message}\nLast view at: file://#{save_page}")
    begin
      wrapper.set_backtrace(ex.backtrace)
    rescue
    end
    raise wrapper
  end
end

#XXX Pause on error?  Pause every step?  Only on keyword is < debugger
module PauseForReturn
  def pause
    if ENV["RSPEC_PAUSABLE"]
      puts "Pausing (until [enter] at #{caller[0]}"
      $stdin.gets
    else
      puts "Pause skipped (RSPEC_PAUSABLE unset) at #{caller[0]}"
    end
  end
end

module HandyXPaths
  class Builder <  XPath::Expression::Self
    include XPath::HTML
    include RSpec::Core::Extensions::InstanceEvalWithArgs
  end

  module Attrs
    def attrs(hash)
      all(*hash.map do |name, value|
        XPath.attr(name) == value
      end)
    end

    def all(*expressions)
      expressions.inject(current) do |chain, expression|
        chain.where(expression)
      end
    end
  end

  def make_xpath(*args, &block)
    xpath = Builder.new
    unless block.nil?
      xpath = xpath.instance_eval_with_args(*args, &block)
    end
    return xpath
  end
end

module XPath
  include HandyXPaths::Attrs
  extend HandyXPaths::Attrs
end

class XPath::Expression
  include HandyXPaths::Attrs
end
=end

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
