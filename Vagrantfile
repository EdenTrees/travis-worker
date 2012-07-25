$: << 'lib'
require 'yaml'
require 'bundler/setup'
require 'travis/worker'

config = Travis::Worker.config.vms

Vagrant::Config.run do |c|
  config.names.each_with_index do |name, num|
    c.vm.define(name) do |box|
      box.vm.box = config.name_prefix

      box.vm.forward_port(22, 2220 + num + 1, :name => 'ssh')

      box.vm.customize [
        "modifyvm",   :id,
        "--name",     name,
        "--nictype1", "Am79C973"
      ]
      # see https://github.com/mitchellh/vagrant/issues/912
      box.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]
    end
  end
end
