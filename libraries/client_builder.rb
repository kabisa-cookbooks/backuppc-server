# Helps building client configurations for BackupPC
#
module ClientBuilder
  CLIENT_OPTIONS = %w[
    ipaddress
    name
    owner
    dhcp
    shares
    includes
    excludes
    config
  ] unless const_defined?(:CLIENT_OPTIONS)

  def build_config_for(client, storage)
    @client = client
    @storage = storage

    if client.kind_of?(Chef::Node)
      configure_client_from_node
    elsif client['overrides']
      override_configured_client
    else
      configure_client_from_databag
    end
  end

  private

  def configure_client_from_node
    @storage << @client['bpc']['client'].select do |k, _|
      CLIENT_OPTIONS.include?(k)
    end.merge('ipaddress' => best_ip_for(@client))
  end

  def override_configured_client
    configs = @storage.select do |config|
      config['name'] == @client['overrides']
    end

    @storage.reject! { |cc| cc['name'] == @client['overrides'] }

    configs.each do |config|
      filtered_options.each do |k, v|
        config[k] = v
      end
      @storage << config
    end
  end

  def configure_client_from_databag
    CLIENT_OPTIONS.each do |k|
      unless @client[k]
        fail ArgumentError, %Q{"#{k}" attribute missing in } +
                            %Q{"#{@client['id']}" data bag item}
      end
    end

    @storage << filtered_options
  end

  def best_ip_for(other)
    if other['cloud']
      if node['cloud'] &&
        other['cloud']['provider'] == node['cloud']['provider']
        other['cloud']['local_ipv4']
      else
        other['cloud']['public_ipv4']
      end
    else
      other['ipaddress']
    end
  end

  def filtered_options
    @client.select { |k, _| CLIENT_OPTIONS.include?(k) }
  end
end
