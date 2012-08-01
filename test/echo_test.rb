require "test_helper"

class EchoTest < CapybaraTestCase
  def test_echo
    visit "/"
    fill_in "message", with: "Hello, World!"
    click_on "Submit"
    assert page.has_content? "Echo: Hello, World!"
  end
end
