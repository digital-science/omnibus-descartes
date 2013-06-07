# Redis install and setup
redis_dir = node['descartes']['redis']['base_dir']
redis_etc_dir = node['descartes']['redis']['etc_dir']
redis_data_dir = node['descartes']['redis']['data_dir']
redis_log_dir = node['descartes']['redis']['log_dir']

[ redis_dir, redis_etc_dir, redis_data_dir, redis_log_dir ].each do |dir_name|
  directory dir_name do
    mode '0700'
    recursive true
    owner node['descartes']['user']['username']
  end
end

redis_config_file = File.join(redis_etc_dir, "redis.conf")

# All the config options are attrs that can be overridden
template redis_config_file do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :config => node['descartes']['redis']['config'].to_hash
end

runit_service "redis" do
  options({
    :log_directory => redis_log_dir,
    :data_dir => redis_data_dir,
    :user => "root",
    :bin_dir => "/opt/descartes/embedded/bin",
    :conf_dir => redis_etc_dir
  }).merge(params)
end

if node['descartes']['bootstrap']['enable']
   execute "/opt/descartes/bin/descartes-ctl start redis" do
     retries 20
   end
end
