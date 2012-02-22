#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Recipe:: openjdk
#
# Copyright 2010-2011, Opscode, Inc.
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

pkgs = value_for_platform(
                          ["centos","redhat","fedora"] => {
                            "default" => ["java-1.6.0-openjdk","java-1.6.0-openjdk-devel"]
                          },
                          "default" => ["openjdk-6-jdk","default-jdk"]
                          )

execute "update-java-alternatives" do
  alternative = case [node[:platform], node[:platform_version]]
                when ["ubuntu", "11.04"] then
                  "java-6-openjdk"
                when ["ubuntu", "11.04"] then
                  "java-1.6.0-openjdk"
                else
                  "java-1.6.0-openjdk"
                end

  command "update-java-alternatives -s #{alternative}"
  returns [0,2]
  action :nothing
  only_if { platform?("ubuntu", "debian") }
end

pkgs.each do |pkg|
  package pkg do
    action :install
    notifies :run, "execute[update-java-alternatives]"
  end
end