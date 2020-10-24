# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'bento/ubuntu-20.04'
  config.vm.host_name = 'echo'
  config.vm.network 'private_network', ip: '192.168.33.10'

  # When connecting through SSH forward port 4444 on the vagrant box to 4444 on the host
  config.ssh.extra_args = ['-R', '4444:localhost:4444']

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt install -y build-essential libxml2-dev libxslt1-dev zlib1g-dev firefox-geckodriver ruby ruby-dev
    gem install bundler
    cd /vagrant && bundle install

    # Setup the CAPYBARA_SERVER_HOST so you don't have to think about the IP address when using the selenium_remote driver
    echo 'CAPYBARA_SERVER_HOST=192.168.33.10' > /home/vagrant/.pam_environment
  SHELL
end
