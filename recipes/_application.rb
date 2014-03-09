require 'net/ssh'

package 'rrdtool'
package 'par'

group 'backuppc' do
  action     :create
  group_name node['bpc']['group']
  system     true
end

user 'backuppc' do
  action   :create
  home     node['bpc']['home']
  username node['bpc']['user']
  gid      node['bpc']['group']
  shell    '/bin/false'
  system   true
end

directory 'backuppc_ssh' do
  action :create
  path      "#{node['bpc']['home']}/.ssh"
  owner     node['bpc']['user']
  group     node['bpc']['group']
  mode      00700
  recursive true
end

private_key = OpenSSL::PKey::RSA.new(
  node['bpc']['ssh_private_key'],
  node['bpc']['ssh_password']
).to_s

node.default['bpc']['ssh_public_key']  = [
  Net::SSH::KeyFactory.load_data_private_key(private_key).to_blob
].pack('m0')

execute 'generate_ssh_keys' do
  action  :run
  creates "#{node['bpc']['home']}/.ssh/id_rsa.pub"
  cwd     "#{node['bpc']['home']}/.ssh"
  user    node['bpc']['user']
  group   node['bpc']['group']
  command <<-EOF.gsub(/^ +/, '')
    echo "#{private_key}" > id_rsa
    echo "#{node['bpc']['ssh_public_key']}" > id_rsa.pub

    chmod 0600 id_rsa
    chmod 0644 id_rsa.pub
  EOF
end

directory 'backuppc_backups' do
  action    :create
  path      node['bpc']['backups_path']
  owner     node['bpc']['user']
  group     node['bpc']['group']
  mode      00755
  recursive true
end

directory 'backuppc_conf' do
  action    :create
  path      node['bpc']['conf_path']
  owner     node['bpc']['user']
  group     node['bpc']['group']
  mode      00755
  recursive true
end

directory 'backuppc_run' do
  action    :create
  notifies  :restart, 'service[backuppc]'
  path      node['bpc']['run_path']
  owner     node['bpc']['user']
  group     node['bpc']['group']
  recursive true
end

directory 'backuppc_client_configs' do
  action    :create
  path      "#{node['bpc']['conf_path']}/pc"
  owner     node['bpc']['user']
  group     node['bpc']['group']
  mode      00755
  recursive true
end

remote_file 'rsync_bpc' do
  action   :create
  notifies :run, 'bash[install_rsync_bpc]', :immediately
  source   node['bpc']['rs_source']
  checksum node['bpc']['rs_checksum']
  path     "#{Chef::Config[:file_cache_path]}/backuppc_rsync_bpc.tar.gz"
  mode     00644
end

bash 'install_rsync_bpc' do
  action :nothing
  cwd    Chef::Config[:file_cache_path]
  code   <<-EOF
    tar zxvf backuppc_rsync_bpc.tar.gz
    cd rsync-bpc-#{node['bpc']['rs_version']}
    ./configure
    make
    make install
  EOF
end

remote_file 'backuppc_server' do
  action   :create
  source   node['bpc']['source']
  checksum node['bpc']['checksum']
  path     "#{Chef::Config[:file_cache_path]}/backuppc.tar.gz"
  mode     00644
end

params =
  if File.exists?("#{node['bpc']['conf_path']}/config.pl")
    ['--batch', "--config-path #{node['bpc']['conf_path']}/config.pl"]
  else
    ['--batch',
     "--backuppc-user #{node['bpc']['user']}",
     "--compress-level #{node['bpc']['config']['CompressLevel']}",
     "--config-dir #{node['bpc']['conf_path']}",
     "--cgi-dir #{node['bpc']['cgi_path']}",
     "--scgi-port #{node['bpc']['scgi_port']}",
     "--data-dir #{node['bpc']['backups_path']}",
     "--install-dir #{node['bpc']['home_path']}",
     "--hostname #{node['bpc']['hostname']}",
     "--html-dir #{node['bpc']['assets_path']}",
     "--html-dir-url /#{File.basename(node['bpc']['assets_path'])}",
     "--log-dir #{node['bpc']['log_path']}",
     "--run-dir #{node['bpc']['run_path']}"]
  end

bash 'install_backuppc_server' do
  action   :run
  notifies :restart, 'service[backuppc]'
  not_if   'test -d ' + node['bpc']['home_path']
  cwd      Chef::Config[:file_cache_path]
  code     <<-EOF
    tar zxvf backuppc.tar.gz
    cd BackupPC-#{node['bpc']['version']}
    perl configure.pl #{params.join(' ')}
  EOF
end

template 'backuppc_conf' do
  action   :create
  notifies :reload, 'service[backuppc]'
  only_if  { node['bpc']['config'].keys.any? }
  source   'config.pl.erb'
  path     "#{node['bpc']['conf_path']}/config.pl"
  owner    node['bpc']['user']
  group    node['bpc']['group']
  mode     00640
end

template 'backuppc_htpasswd' do
  action   :create
  notifies :reload, 'service[apache2]'
  not_if   { node['bpc']['htpasswd'].empty? }
  source   'htpasswd.erb'
  path     "#{node['bpc']['conf_path']}/htpasswd"
  owner    node['apache']['user']
  group    node['apache']['group']
  mode     00600
end

template 'backuppc_init' do
  action   :create
  notifies :restart, 'service[backuppc]'
  source   'init.sh.erb'
  path     '/etc/init.d/backuppc'
  mode     00755
end

service 'backuppc' do
  action   :enable
  supports restart: true, reload: true, start: true, stop: true
end

sudo 'backuppc_service' do
  action    :install
  user      node['bpc']['user']
  nopasswd  true
  runas     'root'
  commands  ['/etc/init.d/backuppc start']
end
