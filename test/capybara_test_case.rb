require 'capybara/minitest'

# Tell Capybara which Rack app to test
Capybara.app = Echo

# Register selenium_remote driver, settings are determined by environment variables:
# * SELENIUM_REMOTE_BROWSER sets the browser to use, defaults to firefox
# * SELENIUM_REMOTE_HOST sets the hostname to use, defaults to localhost
# * SELENIUM_REMOTE_PORT sets the port to use, defaults to 4444 (this matches the geckodriver's default for firefox)
Capybara.register_driver :selenium_remote do |app|
  browser = ENV.fetch('SELENIUM_REMOTE_BROWSER', 'firefox').to_sym
  url     = "http://#{ENV.fetch('SELENIUM_REMOTE_HOST', '127.0.0.1')}:#{ENV.fetch('SELENIUM_REMOTE_PORT', '4444')}"
  Capybara::Selenium::Driver.new(app, browser: browser, url: url)
end

# Set the default driver to based on the ENV variable CAPYBARA_DRIVER, if empty
# this defaults selenium_headless to allow tests with JavaScript.
Capybara.default_driver = ENV.fetch('CAPYBARA_DRIVER', 'selenium_headless').to_sym
# Change the server to webrick since this project is not using puma
Capybara.server = :webrick
# Change where Capybara saves output, the default is tmp in the project root, override with ENV variable
# CAPYBARA_SAVE_PATH
Capybara.save_path = ENV.fetch('CAPYBARA_SAVE_PATH', File.realpath('../tmp', File.dirname(__FILE__)))
# Change the Capybara server host and port based on ENV variables
# These ENV variables are relevant when working with selenium on another machine
Capybara.server_host = ENV['CAPYBARA_SERVER_HOST'] if ENV.include?('CAPYBARA_SERVER_HOST')
Capybara.server_port = ENV['CAPYBARA_SERVER_PORT'].to_i if ENV.include?('CAPYBARA_SERVER_PORT')

# Base test case class to use for tests using Capybara
class CapybaraTestCase < MiniTest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  # setup is run before each test, it ensures that the Capybara.app_host is
  # set properly, it also applies the set screen size
  def setup
    return if page.server.nil?

    app_port          = Capybara.server_port || page.server.port
    Capybara.app_host = "http://#{Capybara.server_host}:#{app_port}"
    set_screen_size
  end

  # teardown is run after each test, it saves a screenshot if the last test
  # failed and resets Capybara for the next test
  def teardown
    save_screenshot("#{name}.png") unless page.server.nil? || passed?

    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end

  # Set the selenium screen size based on two environment variables:
  # * SELENIUM_SCREEN_SIZE containing dimensions in the format WIDTHxHEIGHT (for example 800x600) or a named
  #   label (iphone_6, desktop, etc.), defaults to desktop (1400x1400)
  # * SELENIUM_SCREEN_TURNED will reverse the values for WIDTH and HEIGHT, this is useful when using a shortcut
  #   like iphone_x and emulate a turned screen
  def set_screen_size
    screen_sizes = {
      'galaxy_s9' => '360x740',
      'iphone_6' => '375x667', 'iphone_6_plus' => '414x736',
      'iphone_7' => '375x667', 'iphone_7_plus' => '414x736',
      'iphone_8' => '375x667', 'iphone_8_plus' => '414x736',
      'iphone_x' => '375x812',
      'ipad' => '768x1024',
      'desktop' => '1400x1400'
    }

    screen_size = ENV.fetch('SELENIUM_SCREEN_SIZE', 'desktop')
    screen_size = screen_sizes.fetch(screen_size) if screen_sizes.include?(screen_size)
    screen_size ||= screen_sizes[:desktop]

    screen_size = screen_size.split('x')
    screen_size = screen_size.reverse if ENV.include?('SELENIUM_SCREEN_TURNED')

    page.driver.browser.manage.window.size = Selenium::WebDriver::Dimension.new(*screen_size)
  end
end
