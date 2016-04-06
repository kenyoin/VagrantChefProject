default['postgresql']['enable_pgdg_apt'] = true
default['postgresql']['enable_pgdg_yum'] = true
default['postgresql']['use_pgdg_packages'] = true

default['postgresql']['server']['config_change_notify'] = :restart
default['postgresql']['assign_postgres_password'] = true

# Establish default database name
default['postgresql']['database_name'] = 'template1'

# Sets OS init system (upstart, systemd, ...), instead of relying on Ohai
default['postgresql']['server']['init_package'] =
  case node['platform']
  when 'redhat', 'centos', 'scientific', 'oracle'
    case
    when node['platform_version'].to_f < 6.0
      'sysv'
    when node['platform_version'].to_f < 7.0
      'upstart'
    else
      'systemd'
    end
  else
    'upstart'
  end

default['postgresql']['version'] = "9.4"

default['postgresql']['client']['packages'] = ["postgresql94-devel"]
default['postgresql']['server']['packages'] = ["postgresql94-server"]
default['postgresql']['contrib']['packages'] = ["postgresql94-contrib"]

default['postgresql']['setup_script'] = "postgresql-setup"
default['postgresql']['server']['service_name'] = "postgresql"

default['postgresql']['client']['packages'] = ['postgresql-devel']
default['postgresql']['server']['packages'] = ['postgresql-server']
default['postgresql']['contrib']['packages'] = ['postgresql-contrib']


default['postgresql']['pg_hba'] = [
  { :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'peer' },
  { :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'trust' },
  { :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust' },
]

case node['platform_family']
when 'centos'
default['postgresql']['config']['listen_addresses'] = 'localhost'
default['postgresql']['config']['port'] = 5432
default['postgresql']['config']['max_connections'] = 100
default['postgresql']['config']['shared_buffers'] = '32MB'
default['postgresql']['config']['wal_buffers'] = '32MB'
default['postgresql']['config']['logging_collector'] = true
default['postgresql']['config']['log_directory'] = 'pg_log'
default['postgresql']['config']['log_filename'] = 'postgresql-%a.log'
default['postgresql']['config']['log_truncate_on_rotation'] = true
default['postgresql']['config']['log_rotation_age'] = '1d'
default['postgresql']['config']['log_rotation_size'] = 0
default['postgresql']['config']['datestyle'] = 'iso, mdy'
default['postgresql']['config']['lc_messages'] = 'en_US.UTF-8'
default['postgresql']['config']['lc_monetary'] = 'en_US.UTF-8'
default['postgresql']['config']['lc_numeric'] = 'en_US.UTF-8'
default['postgresql']['config']['lc_time'] = 'en_US.UTF-8'
default['postgresql']['config']['default_text_search_config'] = 'pg_catalog.english'
end

default['postgresql']['password']['postgres'] = 'md5cae31bc247ad84a02394a8b12ff92d76'
default['postgresql']['initdb_locale'] = 'UTF-8'