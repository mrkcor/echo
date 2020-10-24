require 'capybara/minitest'

# Tell Capybara which Rack app to test
Capybara.app = Echo
# Set the default driver to selenium to allow tests with JavaScript
Capybara.default_driver = :selenium_headless
# Change the server to webrick since this project is not using puma
Capybara.server = :webrick
# Change where Capybara saves output
Capybara.save_path = File.realpath('../tmp', File.dirname(__FILE__))

# Base test case class to use for tests using Capybara
class CapybaraTestCase < MiniTest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  # setup is run before each test and sets up the environment appropriately,
  # the code should pretty much explain itself
  def setup
    # do something ?
  end

  # teardown is run after each test, it saves a screenshot if the last test
  # failed and resets Capybara for the next test
  def teardown
    save_screenshot("#{name}.png") unless passed?
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
