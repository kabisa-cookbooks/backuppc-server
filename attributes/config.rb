include_attribute 'backuppc::default'

conf = default['backuppc']['conf']
conf['ServerHost']                  = node['backuppc']['apache']['hostname']
conf['ServerPort']                  = -1
conf['ServerMesgSecret']            = ''
conf['MyPath']                      = '/bin'
conf['UmaskMode']                   = '027'
conf['FillCycle']                   = 7
conf['WakeupSchedule']              = [3,0,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
conf['PoolV3Enabled']               = 0
conf['MaxBackups']                  = 6
conf['MaxUserBackups']              = 4
conf['MaxPendingCmds']              = 15
conf['CmdQueueNice']                = 10
conf['MaxBackupPCNightlyJobs']      = 4
conf['BackupPCNightlyPeriod']       = 4
conf['PoolSizeNightlyUpdatePeriod'] = 16
conf['MaxOldLogFiles']              = 30
conf['DfPath']                      = '/bin/df'
conf['DfCmd']                       = '$dfPath $topDir'
conf['SplitPath']                   = '/usr/bin/split'
conf['ParPath']                     = '/usr/bin/par'
conf['CatPath']                     = '/bin/cat'
conf['GzipPath']                    = '/bin/gzip'
conf['Bzip2Path']                   = '/bin/bzip2'
conf['RsyncBackupPCPath']           = '/usr/local/bin/rsync_bpc'
conf['DfMaxUsagePct']               = 80
conf['DHCPAddressRanges']           = []
conf['BackupPCUser']                = node['backuppc']['user']
conf['TopDir']                      = node['backuppc']['backups_path']
conf['ConfDir']                     = node['backuppc']['conf_path']
conf['LogDir']                      = node['backuppc']['log_path']
conf['RunDir']                      = node['backuppc']['run_path']
conf['InstallDir']                  = node['backuppc']['home_path']
conf['CgiDir']                      = node['backuppc']['cgi_path']
conf['BackupPCUserVerify']          = 1
conf['HardLinkMax']                 = 31999
conf['PerlModuleLoad']              = 'undef'
conf['ServerInitdPath']             = '/etc/init.d/backuppc'
conf['ServerInitdStartCmd']         = "$sshPath -q -x -l #{node['backuppc']['client']['user']} $serverHost $serverInitdPath start < /dev/null >& /dev/null";
conf['FullPeriod']                  = 6.97
conf['IncrPeriod']                  = 0.97
conf['FullKeepCnt']                 = [4,3,2,1]
conf['FullKeepCntMin']              = 1
conf['FullAgeMax']                  = 365
conf['IncrKeepCnt']                 = 6
conf['IncrKeepCntMin']              = 1
conf['IncrAgeMax']                  = 30
conf['BackupsDisable']              = 0
conf['RestoreInfoKeepCnt']          = 20
conf['ArchiveInfoKeepCnt']          = 20
conf['BackupFilesOnly']             = 'undef'
conf['BackupFilesExclude']          = ['/tmp',
                                       '/proc',
                                       '/sys',
                                       '*.pem',
                                       'id_rsa',
                                       '.bash_history',
                                       '/var/logs',
                                       '/usr/src',
                                       '/opt/chef']
conf['BlackoutBadPingLimit']        = 3
conf['BlackoutGoodCnt']             = -1
conf['BlackoutPeriods']             = '[{ hourBegin => 6.0, hourEnd => 23.0, weekDays => [1,2,3,4,5] }]'
conf['BackupZeroFilesIsFatal']      = 1
conf['XferMethod']                  = 'rsync'
conf['XferLogLevel']                = 1
conf['ClientCharset']               = ''
# conf['RsyncClientCmd']              = "$sshPath -q -x -l backupper $host $rsyncPath $argList+"
conf['RsyncClientPath']             = 'sudo /usr/bin/rsync'
conf['SshPath']                     = '/usr/bin/ssh'
conf['RsyncSshArgs']                = ['-e', "'#{conf['SshPath']} -l #{node['backuppc']['client']['user']}'"]
conf['RsyncShareName']              = '/'
conf['RsyncFullArgsExtra']          = ['--checksum']
conf['RsyncArgs']                   = ['--super',
                                       '--recursive',
                                       '--protect-args',
                                       '--numeric-ids',
                                       '--perms',
                                       '--owner',
                                       '--group',
                                       '-D',
                                       '--times',
                                       '--links',
                                       '--hard-links',
                                       '--delete',
                                       '--partial',
                                       '--log-format="log: %o %i %B %8U,%8G %9l %f%L"',
                                       '--stats']
conf['RsyncArgsExtra']              = []
conf['RsyncRestoreArgs']            = 'undef'
conf['FixedIPNetBiosNameCheck']     = 0
conf['PingPath']                    = '/bin/ping'
conf['PingCmd']                     = '$pingPath -c 1 -w 3 $host'
conf['PingMaxMsec']                 = 1000
conf['CompressLevel']               = 3
conf['ClientTimeout']               = 72000
conf['MaxOldPerPCLogFiles']         = 30
conf['DumpPreUserCmd']              = 'undef'
conf['DumpPostUserCmd']             = 'undef'
conf['DumpPreShareCmd']             = 'undef'
conf['DumpPostShareCmd']            = 'undef'
conf['RestorePreUserCmd']           = 'undef'
conf['RestorePostUserCmd']          = 'undef'
conf['ArchivePreUserCmd']           = 'undef'
conf['ArchivePostUserCmd']          = 'undef'
conf['UserCmdCheckStatus']          = 1
conf['ClientNameAlias']             = 'undef'
conf['SendmailPath']                = '/usr/sbin/sendmail'
conf['EMailNotifyMinDays']          = 1
conf['EMailFromUserName']           = ''
conf['EMailAdminUserName']          = ''
conf['EMailUserDestDomain']         = ''
conf['EMailNoBackupEverSubj']       = 'undef'
conf['EMailNoBackupEverMesg']       = 'undef'
conf['EMailNotifyOldBackupDays']    = 7.0
conf['EMailNoBackupRecentSubj']     = 'undef'
conf['EMailNoBackupRecentMesg']     = 'undef'
conf['EMailHeaders']                = [ "MIME-Version: 1.0\n",
                                        'Content-Type: text/plain; ',
                                        'charset=\"utf-8\"'].join
conf['CgiAdminUserGroup']           = ''
conf['CgiAdminUsers']               = 'admin'
conf['SCGIServerPort']              = 10268
conf['CgiURL']                      = '/'
conf['RrdToolPath']                 = '/usr/bin/rrdtool'
conf['Language']                    = 'en'
conf['CgiDateFormatMMDD']           = 2
conf['CgiNavBarAdminAllHosts']      = 1
conf['CgiSearchBoxEnable']          = 1
conf['CgiHeaders']                  = '<meta http-equiv="pragma" content="no-cache">'
conf['CgiImageDir']                 = "#{node['backuppc']['assets_path']}"
conf['CgiExt2ContentType']          = {}
conf['CgiImageDirURL']              = "/#{File.basename(node['backuppc']['assets_path'])}"
conf['CgiCSSFile']                  = 'BackupPC_stnd.css'
conf['CgiUserConfigEditEnable']     = 0
conf['ArchiveDest']                 = node['backuppc']['archive_path']
conf['ArchiveComp']                 = 'bzip2'
conf['ArchivePar']                  = 0
conf['ArchiveSplit']                = 100
conf['ArchiveClientCmd']            = '$Installdir/bin/BackupPC_archiveHost'
conf['CgiNavBarLinks']              = '[
  {
    link  => "?action=view&type=docs",
    lname => "Documentation",
  },
  {
    link  => "http://backuppc.wiki.sourceforge.net",
    name  => "Wiki",
  },
  {
    link  => "http://backuppc.sourceforge.net",
    name  => "SourceForge"
  }
]'
conf['CgiStatusHilightColor']       = '{
  Reason_backup_failed           => "#ffcccc",
  Reason_backup_done             => "#ccffcc",
  Reason_no_ping                 => "#ffff99",
  Reason_backup_canceled_by_user => "#ff9900",
  Status_backup_in_progress      => "#66cc99",
  Disabled_OnlyManualBackups     => "#d1d1d1",
  Disabled_AllBackupsDisabled    => "#d1d1d1"
}'
conf['ClientCharsetLegacy']         = 'iso-8859-1'
conf['SmbShareName']                = 'C$'
conf['SmbShareUserName']            = ''
conf['SmbSharePasswd']              = ''
conf['SmbClientPath']               = ''
conf['SmbClientFullCmd']            = '$smbClientPath \\\\$host\\$shareName $I_option -U $userName -E -d 1 -c tarmode\\ full -Tc$X_option - $fileList'
conf['SmbClientIncrCmd']            = '$smbClientPath \\\\$host\\$shareName $I_option -U $userName -E -d 1 -c tarmode\\ full -TcN$X_option $timeStampFile - $fileList'
conf['SmbClientRestoreCmd']         = '$smbClientPath \\\\$host\\$shareName $I_option -U $userName -E -d 1 -c tarmode\\ full -Tx -'
conf['TarShareName']                = '/'
conf['TarClientCmd']                = '$sshPath -q -x -n -l #{node['backuppc']['client']['user']} $host env LC_ALL=C $tarPath -c -v -f - -C $shareName+ --totals'
conf['TarFullArgs']                 = '$fileList+'
conf['TarIncrArgs']                 = '--newer=$incrDate+ $fileList+'
conf['TarClientRestoreCmd']         = '$sshPath -q -x -l #{node['backuppc']['client']['user']} $host env LC_ALL=C $tarPath -x -p --numeric-owner --same-owner -v -f - -C $shareName+'
conf['TarClientPath']               = '/bin/tar'
conf['RsyncdClientPort']            = 873
conf['RsyncdUserName']              = ''
conf['RsyncdPasswd']                = ''
conf['FtpShareName']                = ''
conf['FtpUserName']                 = ''
conf['FtpPasswd']                   = ''
conf['FtpPassive']                  = 1
conf['FtpBlockSize']                = 10240
conf['FtpPort']                     = 21
conf['FtpTimeout']                  = 120
conf['FtpFollowSymlinks']           = 0
conf['NmbLookupPath']               = ''
conf['NmbLookupCmd']                = '$nmbLookupPath -A $host'
conf['NmbLookupFindHostCmd']        = '$nmbLookupPath $host'
conf['EMailNotifyOldOutlookDays']   = '5.0'
conf['EMailOutlookBackupSubj']      = 'undef'
conf['EMailOutlookBackupMesg']      = 'undef'
conf['CgiUserHomePageCheck']        = ''
conf['CgiUserUrlCreate']            = 'mailto:%s'
conf['CgiUserConfigEdit']           = '{
  FullPeriod                => 1,
  IncrPeriod                => 1,
  FillCycle                 => 1,
  FullKeepCnt               => 1,
  FullKeepCntMin            => 1,
  FullAgeMax                => 1,
  IncrKeepCnt               => 1,
  IncrKeepCntMin            => 1,
  IncrAgeMax                => 1,
  RestoreInfoKeepCnt        => 1,
  ArchiveInfoKeepCnt        => 1,
  BackupFilesOnly           => 1,
  BackupFilesExclude        => 1,
  BackupsDisable            => 1,
  BlackoutBadPingLimit      => 1,
  BlackoutGoodCnt           => 1,
  BlackoutPeriods           => 1,
  BackupZeroFilesIsFatal    => 1,
  ClientCharset             => 1,
  ClientCharsetLegacy       => 1,
  XferMethod                => 1,
  XferLogLevel              => 1,
  SmbShareName              => 1,
  SmbShareUserName          => 1,
  SmbSharePasswd            => 1,
  SmbClientFullCmd          => 0,
  SmbClientIncrCmd          => 0,
  SmbClientRestoreCmd       => 0,
  TarShareName              => 1,
  TarFullArgs               => 1,
  TarIncrArgs               => 1,
  TarClientCmd              => 0,
  TarClientRestoreCmd       => 0,
  TarClientPath             => 0,
  RsyncShareName            => 1,
  RsyncdClientPort          => 1,
  RsyncdPasswd              => 1,
  RsyncdUserName            => 1,
  RsyncdAuthRequired        => 1,
  RsyncArgs                 => 1,
  RsyncArgsExtra            => 1,
  RsyncFullArgsExtra        => 1,
  RsyncSshArgs              => 1,
  RsyncRestoreArgs          => 1,
  RsyncClientPath           => 0,
  FtpShareName              => 1,
  FtpUserName               => 1,
  FtpPasswd                 => 1,
  FtpBlockSize              => 1,
  FtpPort                   => 1,
  FtpTimeout                => 1,
  FtpFollowSymlinks         => 1,
  FtpRestoreEnabled         => 1,
  ArchiveDest               => 1,
  ArchiveComp               => 1,
  ArchivePar                => 1,
  ArchiveSplit              => 1,
  ArchiveClientCmd          => 0,
  FixedIPNetBiosNameCheck   => 1,
  NmbLookupCmd              => 0,
  NmbLookupFindHostCmd      => 0,
  PingMaxMsec               => 1,
  PingCmd                   => 0,
  ClientTimeout             => 1,
  MaxOldPerPCLogFiles       => 1,
  CompressLevel             => 1,
  ClientNameAlias           => 1,
  DumpPreUserCmd            => 0,
  DumpPostUserCmd           => 0,
  RestorePreUserCmd         => 0,
  RestorePostUserCmd        => 0,
  ArchivePreUserCmd         => 0,
  ArchivePostUserCmd        => 0,
  DumpPostShareCmd          => 0,
  DumpPreShareCmd           => 0,
  UserCmdCheckStatus        => 0,
  EMailNotifyMinDays        => 1,
  EMailFromUserName         => 1,
  EMailAdminUserName        => 1,
  EMailUserDestDomain       => 1,
  EMailNoBackupEverSubj     => 1,
  EMailNoBackupEverMesg     => 1,
  EMailNotifyOldBackupDays  => 1,
  EMailNoBackupRecentSubj   => 1,
  EMailNoBackupRecentMesg   => 1,
  EMailNotifyOldOutlookDays => 1,
  EMailOutlookBackupSubj    => 1,
  EMailOutlookBackupMesg    => 1,
  EMailHeaders              => 1,
}'
