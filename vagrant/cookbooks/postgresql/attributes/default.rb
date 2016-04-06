default['postgresql']['enable_pgdg_apt'] = false
default['postgresql']['enable_pgdg_yum'] = false
default['postgresql']['use_pgdg_packages'] = false

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

case node['platform']
when "redhat", "centos", "scientific", "oracle"

  default['postgresql']['version'] = "9.4"

  default['postgresql']['client']['packages'] = ["postgresql94-devel"]
  default['postgresql']['server']['packages'] = ["postgresql94-server"]
  default['postgresql']['contrib']['packages'] = ["postgresql94-contrib"]

  default['postgresql']['setup_script'] = "postgresql-setup"
  default['postgresql']['server']['service_name'] = "postgresql"

  if node['platform_version'].to_f >= 6.0 && node['postgresql']['version'].to_f == 9.4
    default['postgresql']['client']['packages'] = ['postgresql-devel']
    default['postgresql']['server']['packages'] = ['postgresql-server']
    default['postgresql']['contrib']['packages'] = ['postgresql-contrib']
  end

  if node['platform_version'].to_f >= 7.0
    default['postgresql']['version'] = '9.2'
    default['postgresql']['client']['packages'] = ['postgresql-devel']
    default['postgresql']['server']['packages'] = ['postgresql-server']
    default['postgresql']['contrib']['packages'] = ['postgresql-contrib']
  end
end

case node['platform_family']
when 'rhel', 'fedora', 'suse'
  default['postgresql']['config']['listen_addresses'] = '*'
  default['postgresql']['config']['port'] = 5432
  default['postgresql']['config']['max_connections'] = 100
  default['postgresql']['config']['shared_buffers'] = '32MB'
  default['postgresql']['config']['logging_collector'] = true
  default['postgresql']['config']['log_directory'] = 'pg_log'
  default['postgresql']['config']['log_filename'] = 'postgresql-%a.log'
  default['postgresql']['config']['log_truncate_on_rotation'] = true
  default['postgresql']['config']['log_rotation_age'] = '1d'
  default['postgresql']['config']['log_rotation_size'] = 0
  default['postgresql']['config']['datestyle'] = 'iso, mdy'
  default['postgresql']['config']['lc_messages'] = 'ja_JP.UTF-8"'
  default['postgresql']['config']['lc_monetary'] = 'ja_JP.UTF-8"'
  default['postgresql']['config']['lc_numeric'] = 'ja_JP.UTF-8"'
  default['postgresql']['config']['lc_time'] = 'ja_JP.UTF-8"'
  default['postgresql']['config']['default_text_search_config'] = 'pg_catalog.english'
end

default['postgresql']['pg_hba'] = [
  { :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust' },
  { :type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'trust' },
]

default['postgresql']['password']['postgres'] = "md5cae31bc247ad84a02394a8b12ff92d76"

default['postgresql']['initdb_locale'] = 'UTF-8'
