package 'rrdtool'
package 'par'

user 'backuppc' do
  action   :create
  username node['backuppc']['user']
  system   true
  shell    '/bin/false'
end

directory 'backuppc_backups' do
  action    :create
  path      node['backuppc']['backups_path']
  owner     node['backuppc']['user']
  mode      00755
  recursive true
end

directory 'backuppc_conf' do
  action    :create
  path      node['backuppc']['conf_path']
  owner     node['backuppc']['user']
  mode      00755
  recursive true
end

directory 'backuppc_run' do
  action    :create
  notifies  :restart, 'service[backuppc]'
  path      node['backuppc']['run_path']
  owner     node['backuppc']['user']
  recursive true
end

remote_file 'rsync_bpc' do
  action   :create
  notifies :run, 'bash[install_rsync_bpc]', :immediately
  source   node['backuppc']['rsync_bpc_source']
  checksum node['backuppc']['rsync_bpc_checksum']
  path     "#{Chef::Config[:file_cache_path]}/backuppc_rsync_bpc.tar.gz"
  mode     00644
end

bash 'install_rsync_bpc' do
  action :nothing
  cwd    Chef::Config[:file_cache_path]
  code   <<-EOF
    tar zxvf backuppc_rsync_bpc.tar.gz
    cd rsync-bpc-#{node['backuppc']['rsync_bpc_version']}
    ./configure
    make
    make install
  EOF
end

remote_file 'backuppc_server' do
  action   :create
  source   node['backuppc']['source']
  checksum node['backuppc']['checksum']
  path     "#{Chef::Config[:file_cache_path]}/backuppc.tar.gz"
  mode     00644
end

params =
  if File.exists?("#{node['backuppc']['conf_path']}/config.pl")
    ['--batch', "--config-path #{node['backuppc']['conf_path']}/config.pl"]
  else
    ['--batch',
     "--backuppc-user #{node['backuppc']['user']}",
     "--compress-level #{node['backuppc']['conf']['CompressLevel']}",
     "--config-dir #{node['backuppc']['conf_path']}",
     "--cgi-dir #{node['backuppc']['cgi_path']}",
     "--scgi-port #{node['backuppc']['scgi_port']}",
     "--data-dir #{node['backuppc']['backups_path']}",
     "--install-dir #{node['backuppc']['home_path']}",
     "--hostname #{node['backuppc']['apache']['hostname']}",
     "--html-dir #{node['backuppc']['assets_path']}",
     "--html-dir-url /#{File.basename(node['backuppc']['assets_path'])}",
     "--log-dir #{node['backuppc']['log_path']}",
     "--run-dir #{node['backuppc']['run_path']}"]
  end

bash 'install_backuppc_server' do
  action   :run
  notifies :restart, 'service[backuppc]'
  not_if   'test -d ' + node['backuppc']['home_path']
  cwd      Chef::Config[:file_cache_path]
  code     <<-EOF
    tar zxvf backuppc.tar.gz
    cd BackupPC-#{node['backuppc']['version']}
    perl configure.pl #{params.join(' ')}
  EOF
end

template 'backuppc_conf' do
  action   :create
  notifies :reload, 'service[backuppc]'
  only_if  { node['backuppc']['conf'].keys.any? }
  source   'backuppc.config.erb'
  path     "#{node['backuppc']['conf_path']}/config.pl"
  mode     00640
  owner    node['backuppc']['user']
  group    node['backuppc']['group']
end

template 'backuppc_htpasswd' do
  action   :create
  notifies :reload, 'service[apache2]'
  not_if   { node['backuppc']['apache']['htpasswd'].empty? }
  source   'htpasswd.erb'
  path     "#{node['backuppc']['conf_path']}/htpasswd"
  mode     00640
  owner    node['apache']['user']
  group    node['apache']['group']
end

template 'backuppc_init' do
  action   :create
  notifies :restart, 'service[backuppc]'
  source   'backuppc.init.erb'
  path     '/etc/init.d/backuppc'
  mode     00755
end

service 'backuppc' do
  supports restart: true, reload: true, start: true, stop: true
  action [:enable]
end
