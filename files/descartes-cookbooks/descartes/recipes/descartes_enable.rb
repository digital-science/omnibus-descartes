##
# Database setup - heavy infulence from opscode chef server omnibus
# postgres setup recipes 

database_exists = "/opt/descartes/embedded/bin/chpst -u #{node['descartes']['postgresql']['username']} /opt/descartes/embedded/bin/psql -d 'template1' -c 'select datname from pg_database' -x|grep descartes"
user_exists     = "/opt/descartes/embedded/bin/chpst -u #{node['descartes']['postgresql']['username']} /opt/descartes/embedded/bin/psql -d 'template1' -c 'select usename from pg_user' -x|grep #{node['descartes']['postgresql']['sql_user']}"

execute "/opt/descartes/embedded/bin/createdb -T template0 -E UTF-8 descartes" do
  user node['descartes']['postgresql']['username']
  not_if database_exists
  retries 30
  notifies :run, "execute[migrate_database]", :immediately
end

execute "migrate_database" do
  environment({ "PATH" =>"/opt/descartes/embedded/bin:/opt/descartes/bin:/usr/bin:/bin:/usr/sbin:/sbin"})
  command "/opt/descartes/embedded/bin/bundle exec rake db:migrate:up"
  cwd "/opt/descartes/embedded/service/descartes"
  user node['descartes']['postgresql']['username']
  action :nothing
end

execute "/opt/descartes/embedded/bin/psql -d 'descartes' -c \"CREATE USER #{node['descartes']['postgresql']['sql_user']} WITH SUPERUSER ENCRYPTED PASSWORD '#{node['descartes']['postgresql']['sql_password']}'\"" do
  cwd node['descartes']['postgresql']['dir']
  user node['descartes']['postgresql']['username']
  notifies :run, "execute[grant descartes privileges]", :immediately
  not_if user_exists
end

execute "grant descartes privileges" do
  command "/opt/descartes/embedded/bin/psql -d 'descartes' -c \"GRANT ALL PRIVILEGES ON DATABASE descartes TO #{node['descartes']['postgresql']['sql_user']}\""
  user node['descartes']['postgresql']['username']
  action :nothing
end
##

directory node['descartes']['log_dir'] do
  action :create
  owner node['descartes']['user']['username']
  group node['descartes']['user']['username']
  mode "0755"
  recursive true
end

directory node['descartes']['env_dir'] do
  action :create
  mode "0700"
  recursive true
end

# setup runit env variables
node['descartes']['config'].keys.each do |k|
  file "#{node['descartes']['env_dir']}/#{k.upcase}" do
    content node['descartes']['config'][k]
  end
end

runit_service "descartes" do
  options({
    :log_directory => node['descartes']['log_dir'],
    :user => node['descartes']['user']['username'],
    :port => node['descartes']['port'],
    :bin_dir => "/opt/descartes/embedded/bin",
    :env_dir => node['descartes']['env_dir']
  }).merge(params)
end

if node['descartes']['bootstrap']['enable']
   execute "/opt/descartes/bin/descartes-ctl start descartes" do
     retries 20
   end
end
