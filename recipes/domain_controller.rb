# Copyright 2014 Lyle Dietz
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.default['samba4']['globals']['server_role'] = 'active directory domain controller'

node.default['samba4']['shares']['sysvol']['path'] = '/var/lib/samba/sysvol'

node.default['samba4']['shares']['netlogon']['path'] = "#{node.samba4.shares.sysvol.path}/#{node.samba4.globals.realm.downcase}/scripts"

include_recipe 'samba4::default'

directory node.samba4.shares.sysvol.path do
  action :create
end

directory node.samba4.shares.netlogon.path do
  recursive true
  action :create
end

admin = search(:samba4, 'id:Administrator').first

execute 'create domain' do
  command "samba-tool domain provision --adminpass #{admin['password']} --realm #{node.samba4.globals.realm} --domain #{node.samba4.globals.workgroup}"
  creates '/var/lib/samba/private/krb5.conf'
end

service 'smbd' do
  action [ :stop, :disable ]
end

service 'nmbd' do
  action [ :start, :enable ]
end

service 'samba-ad-dc' do
  action [ :start, :enable ]
end
