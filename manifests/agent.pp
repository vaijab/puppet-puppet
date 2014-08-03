# == Class: puppet::agent
#
# This class configures puppet agent itself and the agent service.
#
# === Parameters
#
# See README.md
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class puppet::agent(
    $enable      = true,
    $ensure      = running,
    $master      = 'puppet',
    $environment = 'production',
    $pluginsync  = true,
    $report      = true,
    $runinterval = 1800,
  ) inherits puppet {
  case $::operatingsystem {
    /(Debian|Ubuntu)/: {
      $service_name   = 'puppet'
      $sysconfig_file = '/etc/default/puppet'
    }
    'Fedora': {
      $service_name   = 'puppet'
      $sysconfig_file = '/etc/sysconfig/puppet'
    }
    /(CentOS|RedHat)/: {
      $service_name   = 'puppet'
      $sysconfig_file = '/etc/sysconfig/puppet'
    }
    default: {
      fail('This class is not supported on your OS.')
    }
  }

  $config_file        = '/etc/puppet/puppet.conf'
  $conf_template      = 'puppet.conf.erb'
  $sysconfig_template = 'sysconfig.erb'

  service { $service_name:
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File[[$config_file],[$sysconfig_file]],
    require    => Package[$puppet::package_name],
  }

  file { $config_file:
    ensure  => file,
    require => Package[$puppet::package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/${conf_template}"),
  }

  file { $sysconfig_file:
    ensure  => file,
    require => Package[$puppet::package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${sysconfig_template}"),
  }
}
