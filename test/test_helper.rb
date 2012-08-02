require_relative "../echo"
require "capybara/dsl"
require "headless"
require "minitest/autorun"

# SELENIUM_SERVER is the IP address or hostname of the system running Selenium
# Server, this is used to determine where to connect to when using one of the
# selenium_remote_* drivers
ENV["SELENIUM_SERVER"] ||= "192.168.33.1"

# SELENIUM_APP_HOST is the IP address or hostname of this system (where the
# tests run against) as reachable for the SELENIUM_SERVER. This is used to set
# the Capybara.app_host when using one of the selenium_remote_* drivers
ENV["SELENIUM_APP_HOST"] ||= "192.168.33.10"

# CAPYBARA_DRIVER is the Capybara driver to use, this defaults to Selenium with
# Firefox
ENV["CAPYBARA_DRIVER"] ||= "selenium_firefox"

# Setup Capybara to work with the Echo application
Capybara.app = Echo

# Set the default driver to CAPYBARA_DRIVER, when you change the driver in one
# of your tests resetting it to the default will ensure that its reset to what
# you specified when starting the tests.
Capybara.default_driver = ENV["CAPYBARA_DRIVER"].to_sym

# CapybaraDriverRegistrar is a helper class that enables you to easily register
# Capybara drivers
class CapybaraDriverRegistrar
  # register a Selenium driver for the given browser to run on the localhost
  def self.register_selenium_local_driver(browser)
    Capybara.register_driver "selenium_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: browser)
    end
  end

  # register a Selenium driver for the given browser to run with a Selenium
  # Server on another host
  def self.register_selenium_remote_driver(browser)
    Capybara.register_driver "selenium_remote_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: :remote, url: "http://#{ENV["SELENIUM_SERVER"]}:4444/wd/hub", desired_capabilities: browser)
    end
  end
end

# Register various Selenium drivers
CapybaraDriverRegistrar.register_selenium_local_driver(:firefox)
CapybaraDriverRegistrar.register_selenium_local_driver(:chrome)
CapybaraDriverRegistrar.register_selenium_remote_driver(:firefox)
CapybaraDriverRegistrar.register_selenium_remote_driver(:chrome)
CapybaraDriverRegistrar.register_selenium_remote_driver(:internet_explorer)

# Base test case class to use for tests using Capybara
class CapybaraTestCase < MiniTest::Unit::TestCase
  include Capybara::DSL

  # setup is run before each test and sets up the environment appropriately,
  # the code should pretty much explain itself
  def setup
    if headless?
      @headless = Headless.new
      @headless.start
    end

    if selenium_remote?
      Capybara.app_host = "http://#{ENV["SELENIUM_APP_HOST"]}:#{page.driver.rack_server.port}"
    end
  end

  # teardown is run after each test, it saves a screenshot if the last test
  # failed and resets Capybara for the next test
  def teardown
    save_screenshot(__name__) unless passed?
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end

  # Determines if a selenium_remote_* driver is being used
  def selenium_remote?
    Capybara.current_driver.to_s =~ /\Aselenium_remote/
  end

  # Determines if the test runs on a headless environment
  def headless?
    ENV["GUI"] == "headless" && !selenium_remote?
  end

  # Saves a screenshot in PNG format with a timestamp and the given name in test/tmp/
  # Note that this code assumes that you're using a Selenium driver
  def save_screenshot(name)
    filename = File.join(File.dirname(__FILE__), "tmp", "#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}_#{name}.png")
    page.driver.browser.save_screenshot(filename)
  end
end
