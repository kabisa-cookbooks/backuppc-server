include_recipe 'build-essential::default'
include_recipe 'postfix::default'
include_recipe 'backuppc-server::_perl'
include_recipe 'backuppc-server::_apache'
include_recipe 'backuppc-server::_application'
include_recipe 'backuppc-server::_clients'
