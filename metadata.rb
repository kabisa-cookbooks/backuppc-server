def read(file, default = '')
  IO.read(File.join(File.dirname(__FILE__), file))
rescue Errno::ENOENT
  default
end

name             'backuppc-server'
maintainer       'Jean Mertz'
maintainer_email 'jean@mertz.fm'
license          'MIT'
description      'Installs and configures BackupPC server'
long_description read('README.md')
version          read('VERSION', '0.1.0')

supports 'debian', '~> 7.1.0'

depends 'apache2', '~> 1.9.6'
depends 'build-essential', '~> 1.4.4'
depends 'perl', '~> 1.2.2'
depends 'postfix', '~> 3.1.4'
depends 'sudo', '~> 2.5.2'
