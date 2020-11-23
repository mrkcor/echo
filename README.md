Echo
==============
This is an example project to demonstrate testing a Rack application (in this case using Sinatra) using Capybara and Selenium with various options, I wrote an accompanying blog article here: https://without-brains.net/2020/10/25/capybara-with-selenium-and-vagrant-without-rails/

This project runs on ruby 2.7.x (but will likely function with 2.6.x too).

If you have any issues, suggestions, improvements, etc. then please log them using GitHub issues.

Usage
-----
This project comes with a very basic Vagrant box.

To run the Rack application run "bundle exec rackup", if you then visit the root you will see a webpage with a text input and button. Entering a text and clicking the button will refresh the page echoing back the message that you entered.

To run the tests run "bundle exec rake test", by default this will run against a headless Firefox (this will require you to have the geckodriver installed).

The following environemnt variables influence how the tests are run:

* CAPYBARA\_DRIVER[=selenium\_headless] is the Capybara driver to use, besides the defaults you can also use selenium\_remote here to run against a Selenium instance running elsewhere
* CAPYBARA\_SAVE\_PATH[=tmp/] is where Capybara saves its pages, screenshots, etc.
* CAPYBARA\_SERVER\_HOST is the IP address to which Capybara binds the Rack server that it starts to run the tests against
* CAPYBARA\_SERVER\_PORT is the portnumber to which Capybara binds the Rack server that it starts to run the tests against
* SELENIUM\_REMOTE\_BROWSER[=firefox] is the browser to use when selecting the selenium\_remote driver
* SELENIUM\_REMOTE\_HOST[=127.0.0.1] is the hostname or IP address where the Selenium instance is running for the selenium\_remote driver
* SELENIUM\_REMOTE\_PORT[=4444] is the port on the SELENIUM\_REMOTE\_HOST where the Selenium instance is running for the selenium\_remote driver
* SELENIUM\_SCREEN\_SIZE[=desktop] is the screen size that the Selenium browser must use, select a named shortcut or enter a direct resolution in the format WIDTHxHEIGHT. Named options are galaxy\_s9, iphone\_6, iphone\_6\_plus, iphone\_7, iphone\_7\_plus, iphone\_8, iphone\_8\_plus, iphone\_x, ipad and desktop
* SELENIUM\_SCREEN\_TURNED can be set to 1 to emulate turning the screen for named resolution

License
-------
Echo is released under the MIT license.

Author
------
[Mark Cornelissen](https://github.com/mrkcor)
