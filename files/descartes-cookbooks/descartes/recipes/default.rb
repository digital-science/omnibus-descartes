# Create descartes user
user node['descartes']['user']['username'] do
  system true
  shell node['descartes']['user']['shell']
  home node['descartes']['user']['home']
end

group node['descartes']['user']['username'] do
  members [ node['descartes']['user']['username'] ]
end

directory "/var/opt/descartes" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

include_recipe "runit"


# Configure postgresql
include_recipe "descartes::postgresql_#{node['descartes']['postgresql']['srv_state']}"
# Redis
include_recipe "descartes::redis_#{node['descartes']['redis']['srv_state']}"
include_recipe "descartes::descartes_enable"

# descartes will need:
# default['descartes']['redis']['config']['port']
#
