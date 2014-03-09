Chef::Recipe.send(:include, ClientBuilder)

client_configs = []

if node['bpc']['chef_server']['enabled'] && !Chef::Config[:solo]
  search(:node, 'recipes:backuppc-client\:\:default').each do |client|
    build_config_for(client, client_configs)
  end
end

bag_name = node['bpc']['standalone']['databag_name']
if node['bpc']['standalone']['enabled'] && Chef::DataBag.list.key?(bag_name)
  data_bag(bag_name).each do |id|
    build_config_for(data_bag_item(bag_name, id), client_configs)
  end
end

template 'backuppc_hosts' do
  action    :create
  notifies  :reload, 'service[backuppc]'
  path      "#{node['bpc']['conf_path']}/hosts"
  source    'hosts.erb'
  owner    node['bpc']['user']
  group    node['bpc']['group']
  mode     00600
  variables clients: client_configs
end

client_configs.each do |client|
  template "client_config_#{client['name']}" do
    action   :create
    notifies :reload, 'service[backuppc]'
    path     "#{node['bpc']['conf_path']}/pc/#{client['name']}.pl"
    source   'hostconfig.pl.erb'
    owner    node['bpc']['user']
    group    node['bpc']['group']
    mode     00600

    variables(
      configs: client['config'].dup.merge(
        'ClientNameAlias' => client['ipaddress'],
        'RsyncShareName' => client['shares'],
        'BackupFilesExclude' => client['excludes'].flatten.uniq,
        'BackupFilesOnly' => client['includes'].flatten.uniq
      )
    )
  end
end
