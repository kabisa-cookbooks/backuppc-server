include_recipe 'apache2::default'

package 'libapache2-mod-scgi'

apache_module 'scgi'

web_app 'backuppc' do
  action   :create
  notifies :restart, 'service[backuppc]'
  template 'backuppc.apache.erb'
end
