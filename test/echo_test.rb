require 'test_helper'

class EchoTest < CapybaraTestCase
  def test_echo_that_passes
    visit '/'
    fill_in 'message', with: 'Hello, World!'
    click_on 'Submit'
    assert page.has_content? 'Echo: Hello, World!'
  end

  def test_echo_that_fails
    visit '/'
    fill_in 'message', with: 'Hello, World!'
    click_on 'Submit'
    assert page.has_content? 'Echo: Goodbye'
  end
end
