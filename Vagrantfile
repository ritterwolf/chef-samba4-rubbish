# -*- mode: ruby -*-
# vi: set ft=ruby :

missing_plugs = []
%w(vagrant-berkshelf vagrant-chef-zero vagrant-omnibus).each do |plug|
  missing_plugs << plug unless Vagrant.has_plugin? plug
end

raise "You are missing the following required plugins:\n\t #{missing_plugs.join "\n\t"}" unless missing_plugs.empty?

override = {}
override = JSON.parse(IO.read 'local.json') if File.exists? 'local.json'
config_controller = {}
config_workstation = {}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.chef_zero.chef_repo_path = 'zero'
  config.omnibus.chef_version = :latest

  config.vm.define 'u1404-dc' do |dc|
    dc.vm.box = 'chef/ubuntu-14.04'
    dc.vm.hostname = 'u1404-dc.udc.lan'
    dc.vm.network 'private_network', ip: '192.168.100.5'

    dc.vm.provision 'chef_client' do |chef|
    end
  end

  config.vm.define 'u1404-ws' do |ws|
    ws.vm.box = 'chef/ubuntu-14.04'
    ws.vm.hostname = 'u1404-ws.udc.lan'
    ws.vm.network 'private_network', ip: '192.168.100.10'

    ws.vm.provision 'chef_client' do |chef|
    end
  end

end
