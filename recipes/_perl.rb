include_recipe 'perl::default'

package 'libexpat1-dev'

%w[ File::Listing
    Archive::Zip
    XML::Parser
    XML::RSS
    Net::FTP
    Net::FTP::RetrHandle
    Net::FTP::AutoReconnect
    SCGI
  ].each { |mod| cpan_module(mod) { force(true) } }

remote_file 'perl_backuppc_xs' do
  action   :create
  notifies :run, 'bash[install_perl_backuppc_xs]', :immediately
  source   node['backuppc']['xs_source']
  checksum node['backuppc']['xs_checksum']
  path     "#{Chef::Config[:file_cache_path]}/backuppc_xs.tar.gz"
  mode     00644
end

bash 'install_perl_backuppc_xs' do
  action :nothing
  cwd    Chef::Config[:file_cache_path]
  code   <<-EOF
    tar zxvf backuppc_xs.tar.gz
    cd BackupPC-XS-#{node['backuppc']['xs_version']}
    perl Makefile.PL
    make
    make install
  EOF
end
