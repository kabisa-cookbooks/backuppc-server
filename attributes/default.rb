# User and group used to run the BackupPC server
#
default['bpc']['user'] = 'backuppc'
default['bpc']['group'] = 'backuppc'

# Home directory for the BackupPC user, used to store the public and private
# SSH keys used by BackupPC to connect to the clients.
#
default['bpc']['home'] = '/var/lib/backuppc'

# If enabled, uses chef-server to search for nodes with the recipe
# `backuppc-client::default` in the run_list. Found nodes will be added as
# clients to the BackupPC server.
#
default['bpc']['chef_server']['enabled'] = true

# If enabled, uses a data bag to add non-chef nodes as clients to the BackupPC
# configuration. A data bag item can also be used to override auto
# configurations generated for nodes found through Chef Server.
#
default['bpc']['standalone']['enabled'] = true

# Data bag name to search for "standalone" nodes and/or chef node overrides.
#
default['bpc']['standalone']['databag_name'] = 'backupables'

# The default user, used to connect to external clients through SSH. This will
# be overwritten on a per-node basis through the `backuppc-client` cookbook.
#
default['bpc']['client']['user'] = 'backupper'

# SSH private key to store on the BackupPC server. This key is used to
# authenticate with clients.
#
default['bpc']['ssh_private_key'] = ''

# Password used to decrypt the private key. It is adviced to get this password
# from an encrypted data bag. If set to `nil`, it is assumed the private key
# is passwordless.
#
default['bpc']['ssh_password'] = nil

# Version constraint for BackupPC application.
#
default['bpc']['version'] = '4.0.0alpha3'
default['bpc']['checksum'] = '4f41d663dcee6f39a2e46ad652958f2bb60dc393'

# Version constraint for BackupPC-specific rsync_bpc utility.
#
default['bpc']['rs_version'] = '3.0.9.3'
default['bpc']['rs_checksum'] = '7d6a3e24bb8f705e16da2b8906b960d9da34e64d'

# Version constraint for BackupPC-specific XS Perl module utility.
#
default['bpc']['xs_version']  = '0.30'
default['bpc']['xs_checksum'] = '1863b94d5662348fd7e9ccc3334a6adab214a779'

# Paths used by BackupPC to store its data
#
default['bpc']['home_path'] = "/opt/backuppc-#{node['bpc']['version']}"
default['bpc']['backups_path'] = '/mnt/backuppc/backups'
default['bpc']['archive_path'] = '/mnt/backuppc/archive'
default['bpc']['conf_path'] = '/etc/backuppc'
default['bpc']['log_path'] = '/var/log/backuppc'
default['bpc']['run_path'] = '/var/run/backuppc'
default['bpc']['cgi_path'] = "#{node['bpc']['home_path']}/cgi-bin"
default['bpc']['assets_path'] = "#{node['bpc']['cgi_path']}/assets"

# SCGI port used by Apache and BackupPC to communicate to eachother
#
default['bpc']['scgi_port'] = 10268

# Hostname used as BackupPC name in web interface
#
default['bpc']['hostname'] = 'backuppc'

# Content of `.htpasswd` file used by Apache and BackupPC to restrict BackupPC
# admin rights to specific users. To allow admin rights, you should generate a
# htpasswd file and copy the contents to this attribute.
#
# Example:
#   $ htpasswd -c temp_htaccess admin
#   $ cat temp_htaccess | pbcopy
#
#   Now paste the contents of your clipboard into this attribute.
#
#   Finally you need to add the username `admin` to the `CgiAdminUsers`
#   configuration variable (see attributes/config.rb:1899 for more details).
#
default['bpc']['htpasswd'] = ''

# We need build-essential tools to compile different parts of the BackupPC
# server application.
#
override['build_essential']['compiletime'] = true

# Construction of source URL's to download BackupPC application and
# dependencies.
#
url = 'http://downloads.sourceforge.net/project/backuppc/backuppc-beta'

default['bpc']['source'] = "#{url}/#{node['bpc']['version']}/" \
  "BackupPC-#{default['bpc']['version']}.tar.gz"

default['bpc']['xs_source']   = "#{url}/#{node['bpc']['version']}/" \
  "BackupPC-XS-#{default['bpc']['xs_version']}.tar.gz"

default['bpc']['rs_source'] = "#{url}/#{node['bpc']['version']}/" \
  "rsync-bpc-#{default['bpc']['rs_version']}.tar.gz"
