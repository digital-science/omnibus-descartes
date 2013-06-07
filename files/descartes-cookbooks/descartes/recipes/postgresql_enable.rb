# Much love and thanks to Opscode, for their chef-server
# omnibus packaging. This is 100% based on their work with
# the attribute names changed.

postgresql_dir = node['descartes']['postgresql']['dir']
postgresql_data_dir = node['descartes']['postgresql']['data_dir']
postgresql_data_dir_symlink = File.join(postgresql_dir, "data")
postgresql_log_dir = node['descartes']['postgresql']['log_directory']

user node['descartes']['postgresql']['username'] do
  system true
  shell node['descartes']['postgresql']['shell']
  home node['descartes']['postgresql']['home']
end

directory postgresql_log_dir do
  owner node['descartes']['postgresql']['username']
  recursive true
end

directory postgresql_dir do
  owner node['descartes']['postgresql']['username']
  mode "0700"
end

directory postgresql_data_dir do
  owner node['descartes']['postgresql']['username']
  mode "0700"
  recursive true
end

link postgresql_data_dir_symlink do
  to postgresql_data_dir
  not_if { postgresql_data_dir == postgresql_data_dir_symlink }
end

file File.join(node['descartes']['postgresql']['home'], ".profile") do
  owner node['descartes']['postgresql']['username']
  mode "0644"
  content <<-EOH
PATH=#{node['descartes']['postgresql']['user_path']}
EOH
end

if File.directory?("/etc/sysctl.d") && File.exists?("/etc/init.d/procps")
  # smells like ubuntu...
  service "procps" do
    action :nothing
  end

  template "/etc/sysctl.d/90-postgresql.conf" do
    source "90-postgresql.conf.sysctl.erb"
    owner "root"
    mode  "0644"
    variables(node['descartes']['postgresql'].to_hash)
    notifies :start, 'service[procps]', :immediately
  end
else
  # hope this works...
  execute "sysctl" do
    command "/sbin/sysctl -p /etc/sysctl.conf"
    action :nothing
  end

  bash "add shm settings" do
    user "root"
    code <<-EOF
      echo 'kernel.shmmax = #{node['descartes']['postgresql']['shmmax']}' >> /etc/sysctl.conf
      echo 'kernel.shmall = #{node['descartes']['postgresql']['shmall']}' >> /etc/sysctl.conf
    EOF
    notifies :run, 'execute[sysctl]', :immediately
    not_if "egrep '^kernel.shmmax = ' /etc/sysctl.conf"
  end
end

execute "/opt/descartes/embedded/bin/initdb -D #{postgresql_data_dir}" do
  user node['descartes']['postgresql']['username']
  not_if { File.exists?(File.join(postgresql_data_dir, "PG_VERSION")) }
end

postgresql_config = File.join(postgresql_data_dir, "postgresql.conf")

template postgresql_config do
  source "postgresql.conf.erb"
  owner node['descartes']['postgresql']['username']
  mode "0644"
  variables(node['descartes']['postgresql'].to_hash)
  notifies :restart, 'service[postgresql]' if OmnibusHelper.should_notify?("postgresql")
end

pg_hba_config = File.join(postgresql_data_dir, "pg_hba.conf")

template pg_hba_config do
  source "pg_hba.conf.erb"
  owner node['descartes']['postgresql']['username']
  mode "0644"
  variables(node['descartes']['postgresql'].to_hash)
  notifies :restart, 'service[postgresql]' if OmnibusHelper.should_notify?("postgresql")
end

should_notify = OmnibusHelper.should_notify?("postgresql")

runit_service "postgresql" do
  down node['descartes']['postgresql']['ha']
  control(['t'])
  options({
    :log_directory => postgresql_log_dir,
    :svlogd_size => node['descartes']['postgresql']['svlogd_size'],
    :svlogd_num  => node['descartes']['postgresql']['svlogd_num']
  }.merge(params))
end

if node['descartes']['bootstrap']['enable']
  execute "/opt/descartes/bin/descartes-ctl start postgresql" do
    retries 20
  end
end
