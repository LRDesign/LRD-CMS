require 'capybara/rspec'
require 'selenium-webdriver'
require 'rspec-steps'

Capybara.register_driver(:selenium_chrome) do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.default_driver = :selenium

#module SaveAndOpenOnFail
  #def instance_eval(&block)
    #super(&block)
  #rescue Object => ex
    #wrapper = ex.exception("#{ex.message}\nLast view at: file://#{save_page}")
    #wrapper.set_backtrace(ex.backtrace)
    #raise wrapper
  #end
#end

#module HandyXPaths
  #class Builder <  XPath::Expression::Self
    #include XPath::HTML
    #include RSpec::Core::Extensions::InstanceEvalWithArgs
  #end

  #module Attrs
    #def attrs(hash)
      #all(*hash.map do |name, value|
        #XPath.attr(name) == value
      #end)
    #end

    #def all(*expressions)
      #expressions.inject(current) do |chain, expression|
        #chain.where(expression)
      #end
    #end
  #end

  #def make_xpath(*args, &block)
    #xpath = Builder.new
    #unless block.nil?
      #xpath = xpath.instance_eval_with_args(*args, &block)
    #end
    #return xpath
  #end
#end

#module XPath
  #include HandyXPaths::Attrs
  #extend HandyXPaths::Attrs
#end

#class XPath::Expression
  #include HandyXPaths::Attrs
#end