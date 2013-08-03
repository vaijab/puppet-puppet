# == Class: puppet::master
#
# This class installs puppet master and puppetdb-terminus packages and
# configures puppet master server. It is tested on Puppet v3 or later.
#
# See README.md
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class puppet::master(
    $enable                = true,
    $ensure                = running,
    $storeconfigs          = false,
    $storeconfigs_backend  = 'puppetdb',
    $reports               = 'store,puppetdb',
    $autosign              = false,
    $allow_duplicate_certs = false,
    $environments          = [ 'development',
                               'qa',
                               'staging',
                               'production' ],
    $path_to_env_code      = '/etc/puppet/environments',
    $path_to_hieradata     = '/etc/puppet/hieradata',
    $hiera_hierarchy       = [ 'environments/%{environment}/nodes/%{fqdn}',
                               'environments/%{environment}/roles/%{noderole}',
                               'environments/%{environment}/sites/%{nodesite}',
                               'environments/%{environment}/common' ],
    $hiera_backends        = [ 'yaml' ],
    $puppetdb_server       = $::fqdn,
    $puppetdb_port         = '8081',
    $routes_enabled        = false,
  ) inherits puppet {
  case $::osfamily {
    RedHat: {
      $sysconfig_file = '/etc/sysconfig/puppetmaster'
      $package_name   = 'puppet-server'
    }
    Debian: {
      $sysconfig_file = '/etc/default/puppetmaster'
      $package_name   = 'puppetmaster'
    }
    default: {
      # nothing
    }
  }

  $service_name             = 'puppetmaster'
  $config_file              = '/etc/puppet/puppetmaster.conf'
  $hiera_config_file        = '/etc/puppet/hiera.yaml'
  $hiera_conf_template      = 'hiera.yaml.erb'
  $conf_template            = 'puppetmaster.conf.erb'
  $puppetdb_config_file     = '/etc/puppet/puppetdb.conf'
  $puppetdb_conf_template   = 'puppetdb.conf.erb'
  $routes_config_file       = '/etc/puppet/routes.yaml'
  $routes_conf_template     = 'routes.yaml.erb'
  $sysconfig_template       = 'sysconfig_master.erb'
  $pdb_terminus_package     = 'puppetdb-terminus'

  # Installs puppet-server package
  package { $package_name:
    ensure => installed,
  }

  # Installs puppetdb-terminus package
  package { $pdb_terminus_package:
    ensure => installed,
  }

  # Manages puppetmaster service
  service { $service_name:
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File[[$config_file],[$sysconfig_file],[$hiera_config_file]],
    require    => Package[$package_name],
  }

  # Puppetmaster configuration file
  file { $config_file:
    ensure  => file,
    require => Package[$package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/${conf_template}"),
  }

  # Hiera configuration file
  file { $hiera_config_file:
    ensure  => file,
    require => Package[$package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${hiera_conf_template}"),
  }

  # Where to store non-sensitive hiera data per environment
  file { "${path_to_hieradata}/environments":
    ensure  => directory,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0750',
    require => Package[$package_name],
  }

  # PuppetDB configuration file for puppetmaster
  file { $puppetdb_config_file:
    ensure  => file,
    require => Package[$pdb_terminus_package],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${puppetdb_conf_template}"),
    notify  => Service[$service_name],
  }

  # Puppetmaster daemon startup configuration file
  file { $sysconfig_file:
    ensure  => file,
    require => Package[$package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${sysconfig_template}"),
  }

  # Puppetmaster routes.yaml configuration file will only be used if
  # $routes_enabled is set to true
  if $routes_enabled {$routes_file = 'file'}
  else {$routes_file = 'absent'}

  file { $routes_config_file:
    ensure  => $routes_file,
    require => Package[$package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${routes_conf_template}"),
    notify  => Service[$service_name],
  }
}
