# Backuppc-server cookbook

Installs Backuppc 4 (alpha 3) server

## Requirements

## Platforms

* Debian

### Dependencies

* apache2 (for GUI access)
* perl (to build from source)

## Attributes

### default

Namespace                  | Description                                                                          |Type     | Default
---------                  |-------------                                                                         |-----    |--------
`['backuppc']['client']['user']`              | Name of user to connect to clients                                               | String  | backupper
`['backuppc']['version']`          | BackupPC version    | String  | 4.0.0alpha3
`['backuppc']['checksum']`          | The SHA256 checksum of the tar file that is being downloaded                 | String  | 4f41d663dcee6f39a2e46ad652958f2bb60dc393
`['backuppc']['rsync_bpc_version']`                  | BackupPC custom rsync_bpc version                                | String  | 3.0.9.3
`['backuppc']['rsync_bpc_checksum']`                    | The SHA256 checksum of the tar file that is being downloaded                                               | String  | 7d6a3e24bb8f705e16da2b8906b960d9da34e64d
`['backuppc']['xs_version']`                      | BackupPC XS module version                                                  | String  | 0.3.0
`['backuppc']['xs_checksum']`                      | The SHA256 checksum of the tar file that is being downloaded                                               | String  | 1863b94d5662348fd7e9ccc3334a6adab214a779
`['backuppc']['home_path']`                | Install path                            | String    | /opt/backuppc-4.0.0alpha3
`['backuppc']['backups_path']`                   | Backups path | String    | /mnt/backuppc/backups
`['backuppc']['archive_path']`         | Archives path                                       | String   | /mnt/backuppc/archive
`['backuppc']['conf_path']`                      | Configurations path         | String | /etc/backuppc
`['backuppc']['log_path']`             | Logs path                      | String | /var/log/backuppc
`['backuppc']['run_path']`                       | Path to store pid and socket files                            | String | /var/run/backuppc
`['backuppc']['cgi_path']`              | Path for Apache GCI scripts          | String    | /opt/backuppc-4.0.0alpha3/cgi-bin
`['backuppc']['assets_path']`             | Path to store BackupPC GUI assets  | String    | /opt/backuppc-4.0.0alpha3/cgi-bin/assets
`['backuppc']['scgi_port']`              | SCGI port to connect to from Apache    | Integer    | 10268
`['backuppc']['user']`             | User to run BackupPC           | String    | backuppc
`['backuppc']['group']`              | Group to run BackupPC            | String    | backuppc
`['backuppc']['apache']['hostname']`                  | Hostname to use for Apache config         | String    | backuppc
`['backuppc']['apache']['htpasswd']`             | string of htpasswd entries (user:passwd), comma seperated                 | String    | admin:admin (encrypted)
`['backuppc']['source']`                    | Compilation of above variables to construct download link                | String    |
`['backuppc']['xs_source']`                    | Compilation of above variables to construct download link                | String    |
`['backuppc']['rsync_bpc_source']`                    | Compilation of above variables to construct download link                | String    |

### config

see the `config` attributes file to find all configuration variables for the BackupPC installation. All configuration variables are namespaced under `node['backuppc']['conf']`.

## Recipes

### Default

After setting the above configuration variables, all that is left to do is to include the default recipe:

```ruby
include_recipe 'backuppc-server::default'
```

You can visit the GUI on the `/` top level path.

# License and Author

Author:: Jean Mertz (<jean@mertz.fm>)

Copyright 2014, Kabisa ICT

See LICENSE for license details
