#
# Cookbook Name:: runit
# Recipe:: sysvinit
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# We assume you are sysvinit
svdir_line = 'SV:123456:respawn:/opt/descartes/embedded/bin/runsvdir-start'
execute "echo '#{svdir_line}' >> /etc/inittab" do
  not_if "grep '#{svdir_line}' /etc/inittab"
  notifies :run, "execute[init q]", :immediately
end

execute "init q" do
  action :nothing
end
