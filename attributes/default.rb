node.default['samba4']['globals']['realm'] = node.domain.upcase
node.default['samba4']['globals']['workgroup'] = node.samba4.globals.realm.split('.').first
node.default['samba4']['globals']['server_role'] = 'standalone'

node.default['samba4']['shares'] = {}

node.default['samba4']['join_user'] = 'Administrator'