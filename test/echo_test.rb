require 'test_helper'
require 'pry-byebug'

class EchoTest < CapybaraTestCase
  def test_echo
    visit '/'
    fill_in 'message', with: 'Hello, World!'
    click_on 'Submit'
    assert page.has_content? 'Echo: Hello, World! 2'
  end
end
