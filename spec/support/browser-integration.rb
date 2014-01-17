require 'capybara/rspec'
#require 'selenium-webdriver'
require 'capybara/poltergeist'
require 'rspec-steps'
require 'stringio'

Capybara.register_driver(:selenium_chrome) do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
end

Capybara.javascript_driver = (ENV['CAPYBARA_DRIVER'] || :poltergeist_debug).to_sym

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

  def self.warnings
    @warnings ||= {}
  end

  def self.warn(general, specific=nil)
    warnings.fetch(general) do
      warnings[general] = true
      puts "Warning: #{general}#{specific ? ": #{specific}" : ""}"
    end
  end

  def snapshot(dir)
    require 'fileutils'

    dir = "tmp/#{dir}"

    @frame_dirs ||= Hash.new do |h,k|
      puts "Clearing #{k}"
      FileUtils.rm_rf(k)
      FileUtils.mkdir_p(k)
      h[k] = 0
    end
    frame = (@frame_dirs[dir] += 1)

    path = "#{dir}/#{"%03i" % frame}.png"
    msg = "Saving screenshot: #{path} (from: #{caller[0]})"
    puts msg
    Rails.logger.info(msg)
    page.driver.save_screenshot(path, :full => true)
  rescue Capybara::NotSupportedByDriverError => nsbde
    BrowserTools.warn("Can't use snapshot", nsbde.inspect)
  end
end
