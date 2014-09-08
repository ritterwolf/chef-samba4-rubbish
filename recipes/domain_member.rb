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

node.default['samba4']['globals']['server_role'] = 'member server'
node.default['samba4']['globals']['security'] = 'ADS'
node.default['samba4']['globals']['winbind_use_default_domain'] = true
node.default['samba4']['globals']['winbind_normalize_names'] = true
node.default['samba4']['globals']['winbind_enum_users'] = true
node.default['samba4']['globals']['winbind_enum_groups'] = true

node.default['samba4']['globals']['idmap_config_*_:_backend'] = 'rid'
node.default['samba4']['globals']['idmap_config_*_:_range'] = '1000000 - 1999999'
node.default['samba4']['globals']["idmap_config_#{node.samba4.globals.workgroup}_:_backend"] = 'rid'
node.default['samba4']['globals']["idmap_config_#{node.samba4.globals.workgroup}_:_range"] = '2000000 - 2999999'

include_recipe 'samba4::default'

package 'winbind'

package 'libnss-winbind'
package 'libpam-winbind'

joiner = search(:samba4, "id:#{node.samba4.join_user}").first

service 'winbind' do
  action [ :start, :enable ]
end

execute 'Join AD' do
  command "net ads join -U #{joiner['id']}%#{joiner['password']}"
  # This looks funky, but it stops it waiting for input if we aren't 
  # joined to the domain, and has no effect if we are
  not_if 'echo | net ads testjoin'
  notifies :restart, 'service[winbind]'
end

template '/etc/nsswitch.conf' do
  action :create
end