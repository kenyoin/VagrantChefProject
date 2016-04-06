#
# Cookbook Name:: setup
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
link "/usr/bin/pg_config" do
  to "/usr/pgsql-9.3/bin/pg_config"
end

execute "create-user" do
  user "postgres"
  # sampleをスーパーユーザーとする。
  command "createuser -s sample"
  not_if "psql -U postgres -c \"select * from pg_user where usename='sample'\" | grep -q sample", :user => "postgres"
end

execute "create-database" do
  user "postgres"
  # 所有者をsampleとするsampledbデータベースを作成する。
  command "createdb -O sample sampledb"
  not_if "psql -U postgres -c \"select * from pg_database WHERE datname='sampledb'\" | grep -q sample", :user => "postgres"
end
