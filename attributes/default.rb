default['backuppc']['client']['user'] = 'backupper'

default['backuppc']['version'] = '4.0.0alpha3'
default['backuppc']['checksum'] = '4f41d663dcee6f39a2e46ad652958f2bb60dc393'

default['backuppc']['rsync_bpc_version'] = '3.0.9.3'
default['backuppc']['rsync_bpc_checksum'] = '7d6a3e24bb8f705e16da2b8906b960d9da34e64d'

default['backuppc']['xs_version']  = '0.30'
default['backuppc']['xs_checksum'] = '1863b94d5662348fd7e9ccc3334a6adab214a779'

default['backuppc']['home_path'] = "/opt/backuppc-#{node['backuppc']['version']}"
default['backuppc']['backups_path'] = '/mnt/backuppc/backups'
default['backuppc']['archive_path'] = '/mnt/backuppc/archive'
default['backuppc']['conf_path'] = '/etc/backuppc'
default['backuppc']['log_path'] = '/var/log/backuppc'
default['backuppc']['run_path'] = '/var/run/backuppc'
default['backuppc']['cgi_path'] = "#{node['backuppc']['home_path']}/cgi-bin"
default['backuppc']['assets_path'] = "#{node['backuppc']['cgi_path']}/assets"

default['backuppc']['scgi_port'] = 10268
default['backuppc']['user'] = 'backuppc'
default['backuppc']['group'] = 'backuppc'

default['backuppc']['apache']['hostname'] = 'backuppc'
default['backuppc']['apache']['htpasswd'] = 'admin:$apr1$GXDkdXv7$L.x6QQRK5L0YeU/VDHqdw0'

url = 'http://downloads.sourceforge.net/project/backuppc/backuppc-beta'

default['backuppc']['source'] = "#{url}/#{node['backuppc']['version']}/" +
  "BackupPC-#{default['backuppc']['version']}.tar.gz"

default['backuppc']['xs_source']   = "#{url}/#{node['backuppc']['version']}/" +
  "BackupPC-XS-#{default['backuppc']['xs_version']}.tar.gz"

default['backuppc']['rsync_bpc_source'] =
  "#{url}/#{node['backuppc']['version']}/" +
  "rsync-bpc-#{default['backuppc']['rsync_bpc_version']}.tar.gz"
