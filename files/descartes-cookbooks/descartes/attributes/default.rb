
# User settings
default['descartes']['user']['username'] = "descartes"
default['descartes']['user']['shell'] = "/bin/sh"
default['descartes']['user']['home'] = "/opt/descartes/embedded"

# global bootstrap
default['descartes']['bootstrap']['enable'] = "true"

# Configure postgresql
default['descartes']['postgresql']['srv_state'] = "enable"

# Configure redis
default['descartes']['redis']['srv_state'] = "enable"
default['descartes']['redis']['base_dir'] = "/var/opt/descartes/redis"
default['descartes']['redis']['etc_dir'] = "/var/opt/descartes/redis/etc"
default['descartes']['redis']['data_dir'] = "/var/opt/descartes/redis/data"
default['descartes']['redis']['log_dir'] = "/var/log/descartes/redis"
default['descartes']['redis']['run_dir'] = "/var/opt/descartes/run"

# These are all the redis config options. If you wanted you could override them in a recipe wiht
# override['descartes']['redis']['config']['foo'] = "bar"
# THESE ARE FOR REDIS 2.4!!!
default['descartes']['redis']['config']['daemonize'] = "no"
default['descartes']['redis']['config']['pidfile'] = "#{node['descartes']['redis']['run_dir']}/redis.pid"
default['descartes']['redis']['config']['port'] = 7601 # crazy redis port, in case you're runnig another redis
default['descartes']['redis']['config']['timeout'] = 0
default['descartes']['redis']['config']['loglevel'] = "verbose"
default['descartes']['redis']['config']['logfile'] = "#{node['descartes']['redis']['log_dir']}/redis.log"
default['descartes']['redis']['config']['databases'] = 16
default['descartes']['redis']['config']['save'] = '900 1'
default['descartes']['redis']['config']['save'] = '300 10'
default['descartes']['redis']['config']['save'] = '60  10000'
default['descartes']['redis']['config']['rdbcompression'] = "yes"
default['descartes']['redis']['config']['dbfilename'] = "dump.rdb"
default['descartes']['redis']['config']['dir'] = node['descartes']['redis']['data_dir']
default['descartes']['redis']['config']['slave-serve-stale-data'] = "yes"
# This doesn't seem to be in 2.4.7
#default['descartes']['redis']['config']['slave-priority'] = 100
default['descartes']['redis']['config']['appendonly'] = "no"
default['descartes']['redis']['config']['appendfsync'] = "everysec"
default['descartes']['redis']['config']['no-appendfsync-on-rewrite'] = "no"
default['descartes']['redis']['config']['auto-aof-rewrite-percentage'] = 100
default['descartes']['redis']['config']['auto-aof-rewrite-min-size'] = "64mb"
default['descartes']['redis']['config']['slowlog-log-slower-than'] = 10000
default['descartes']['redis']['config']['slowlog-max-len'] = 128
default['descartes']['redis']['config']['vm-enabled'] = "no"
default['descartes']['redis']['config']['vm-swap-file'] = "/tmp/redis.swap"
default['descartes']['redis']['config']['vm-max-memory'] = 0
default['descartes']['redis']['config']['vm-page-size'] = 32
default['descartes']['redis']['config']['vm-pages'] = 134217728
default['descartes']['redis']['config']['vm-max-threads'] = 4
default['descartes']['redis']['config']['hash-max-zipmap-entries'] = 512
default['descartes']['redis']['config']['hash-max-zipmap-value'] = 64
default['descartes']['redis']['config']['list-max-ziplist-entries'] = 512
default['descartes']['redis']['config']['list-max-ziplist-value'] = 64
default['descartes']['redis']['config']['set-max-intset-entries'] = 512
default['descartes']['redis']['config']['zset-max-ziplist-entries'] = 128
default['descartes']['redis']['config']['zset-max-ziplist-value'] = 64
default['descartes']['redis']['config']['activerehashing'] = "yes"

###
# PostgreSQL
###
default['descartes']['postgresql']['enable'] = true
default['descartes']['postgresql']['ha'] = false
default['descartes']['postgresql']['dir'] = "/var/opt/descartes/postgresql"
default['descartes']['postgresql']['data_dir'] = "/var/opt/descartes/postgresql/data"
default['descartes']['postgresql']['log_directory'] = "/var/log/descartes/postgresql"
default['descartes']['postgresql']['svlogd_size'] = 1000000
default['descartes']['postgresql']['svlogd_num'] = 10
default['descartes']['postgresql']['username'] = "opscode-pgsql"
default['descartes']['postgresql']['shell'] = "/bin/sh"
default['descartes']['postgresql']['home'] = "/var/opt/descartes/postgresql"
default['descartes']['postgresql']['user_path'] = "/opt/descartes/embedded/bin:/opt/descartes/bin:$PATH"
default['descartes']['postgresql']['sql_user'] = "descartes"
default['descartes']['postgresql']['sql_password'] = "braincellsword" # you should probably change this....
default['descartes']['postgresql']['vip'] = "127.0.0.1"
default['descartes']['postgresql']['port'] = 5432
default['descartes']['postgresql']['listen_address'] = 'localhost'
default['descartes']['postgresql']['max_connections'] = 200
default['descartes']['postgresql']['md5_auth_cidr_addresses'] = [ ]
default['descartes']['postgresql']['trust_auth_cidr_addresses'] = [ '127.0.0.1/32', '::1/128' ]
default['descartes']['postgresql']['shmmax'] = kernel['machine'] =~ /x86_64/ ? 17179869184 : 4294967295
default['descartes']['postgresql']['shmall'] = kernel['machine'] =~ /x86_64/ ? 4194304 : 1048575

# Resolves CHEF-3889
if (node['memory']['total'].to_i / 4) > ((node['descartes']['postgresql']['shmmax'].to_i / 1024) - 2097152)
  # guard against setting shared_buffers > shmmax on hosts with installed RAM > 64GB
  # use 2GB less than shmmax as the default for these large memory machines
  default['descartes']['postgresql']['shared_buffers'] = "14336MB"
else
  default['descartes']['postgresql']['shared_buffers'] = "#{(node['memory']['total'].to_i / 4) / (1024)}MB"
end

default['descartes']['postgresql']['work_mem'] = "8MB"
default['descartes']['postgresql']['effective_cache_size'] = "#{(node['memory']['total'].to_i / 2) / (1024)}MB"
default['descartes']['postgresql']['checkpoint_segments'] = 10
default['descartes']['postgresql']['checkpoint_timeout'] = "5min"
default['descartes']['postgresql']['checkpoint_completion_target'] = 0.9
default['descartes']['postgresql']['checkpoint_warning'] = "30s"




## Descartes
#
default['descartes']['base_dir'] = "/var/opt/descartes/redis"
default['descartes']['env_dir'] = "/var/opt/descartes/descartes/env"
default['descartes']['log_dir'] = "/var/log/descartes/descartes"

default['descartes']['port'] = 7600

# Descartes runit env settings
# everything must be a string as it's used as file content
default['descartes']['config']['rack_env'] = "production"
default['descartes']['config']['session_secret'] = "YouWantToChangeThis"
# graphite - you'll want to override these
default['descartes']['config']['graphite_user'] = ""
default['descartes']['config']['graphite_pass'] = ""
default['descartes']['config']['graphite_url'] = ""
# Oauth - you'll want to override these
default['descartes']['config']['oauth_provider'] = ""
default['descartes']['config']['google_oauth_domain'] = ""
default['descartes']['config']['github_client_id'] = ""
default['descartes']['config']['github_client_secret'] = ""
default['descartes']['config']['github_org_id'] = ""

# app
default['descartes']['config']['graph_template'] = "default"
default['descartes']['config']['metrics_update_interval'] = "1h"
default['descartes']['config']['metrics_update_on_boot'] = "true"
default['descartes']['config']['metrics_update_timeout'] = "300"
default['descartes']['config']['use_svg'] = "false"
# Databases
default['descartes']['config']['redistogo_url'] = "redis://localhost:#{node['descartes']['redis']['config']['port']}"
default['descartes']['config']['database_url'] = "postgres://#{node['descartes']['postgresql']['sql_user']}:#{node['descartes']['postgresql']['sql_password']}@localhost/descartes"
