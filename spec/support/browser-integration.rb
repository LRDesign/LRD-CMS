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

module TinyMCETools
  def fill_in_tinymce(id, options = {})
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)
    #raise "tiny MCE fill-in only works with Selenium driver" unless page.driver.class == Capybara::Selenium::Driver

    #browser = page.driver.browser
    page.execute_script("$('##{id}').tinymce().setContent('#{options[:with]}')")
  end
end

module BrowserTools
  def accept_alert
    if poltergeist?
      # do nothing ... really?
      # http://blog.lucascaton.com.br/index.php/2012/06/14/replacing-selenium-by-poltergeist/
    else
      alert = page.driver.browser.switch_to.alert
      alert.accept
    end
  end

  def wait_for_animation
    sleep(1) if poltergeist?
  end

  def poltergeist?
    Capybara.javascript_driver.to_s =~ /poltergeist/
  end
end
