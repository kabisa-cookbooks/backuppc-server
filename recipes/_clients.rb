Chef::Resource::RubyBlock.send(:include, ClientBuilder)

# The constructions of backups configs is wrapped in a `ruby_block` to allow
# for any manipulation of configs to happen during the chef run. Without this
# block, any changes after the compilation phase would be lost.
#
# This is needed for when a wrapper cookbook modifies the client's backup
# strategies during runtime, instead of compile time. An example of this would
# be something like this:
#
#     ruby_block 'manage_backup_strategies' do
#       action :create
#       block do
#         Backupable::DefaultStrategy.new(node)
#         Backupable::BaseStrategy.new(node) if node.recipe?('base::default')
#       end
#     end
#
# the `DefaultStrategy` and `BaseStrategy` classes would set the node's
# attributes `node.bpc.client.includes` and `node.bpc.client.excludes`. This
# needs to be in a `ruby_block`, because the expanded run-list is unavailable
# during compile time, and thus `node.recipe?` might not return true if the
# `base::default` recipe hasn't been compiled yet by Chef.
#
ruby_block 'build_client_backup_configs' do
  action :create
  notifies :reload, 'service[backuppc]'

  block do
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

    hosts = Chef::Resource::Template.new('backuppc_hosts', run_context)
    hosts.path   "#{node['bpc']['conf_path']}/hosts"
    hosts.source 'hosts.erb'
    hosts.cookbook 'backuppc-server'
    hosts.owner  node['bpc']['user']
    hosts.group  node['bpc']['group']
    hosts.mode   00600
    hosts.variables clients: client_configs
    hosts.run_action(:create)

    client_configs.each do |client|
      name = "client_config_#{client['name']}"
      conf = Chef::Resource::Template.new(name, run_context)
      conf.path   "#{node['bpc']['conf_path']}/pc/#{client['name']}.pl"
      conf.source 'hostconfig.pl.erb'
      conf.cookbook 'backuppc-server'
      conf.owner  node['bpc']['user']
      conf.group  node['bpc']['group']
      conf.mode   00600
      conf.variables(
        configs: client['config'].dup.merge(
          'ClientNameAlias' => client['ipaddress'],
          'RsyncShareName' => client['shares'],
          'BackupFilesExclude' => client['excludes'].flatten.uniq,
          'BackupFilesOnly' => client['includes'].flatten.uniq
        )
      )
      conf.run_action(:create)
    end
  end
end
