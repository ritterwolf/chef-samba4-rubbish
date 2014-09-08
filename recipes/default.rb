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

package 'samba'

template '/etc/samba/smb.conf' do
  cookbook 'samba4'
  variables globals: node.samba4.globals, shares: node.samba4.shares
end

service 'smbd' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

service 'nmbd' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

service 'samba-ad-dc' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

service 'winbind' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end
