begin
  shards = {:my_shards => {}}
  Tenant.find(:all).each do |shard|
    shards[:my_shards][shard.database] = {:host => shard.host, :adapter => shard.adapter, :database => shard.database, :username => shard.username, :password => shard.password, :port => shard.port}
  end

  Octopus.setup do |config|
    config.environments = [:development, :production]
    config.shards = shards    
  end

rescue ActiveRecord::StatementInvalid => e
  puts e
end