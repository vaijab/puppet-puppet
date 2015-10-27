# == Class: puppet
#
# This class installs puppet package. It should not be called directly.
# It is inherited by <code>puppet::agent</code> and <code>puppet::master</code>
# classes.
#
#
# === Parameters
#
# See README.md
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class puppet(
    $vardir  = '/var/lib/puppet',
    $confdir = '/etc/puppet',
    $logdir  = '/var/log/puppet',
    $rundir  = '/var/run/puppet',
    $ssldir  = '$vardir/ssl',
    $package = 'installed'
  ) {
  case $::osfamily {
    'RedHat': {
      $package_name = 'puppet'
    }
    'Debian': {
      $package_name = 'puppet'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  include puppet::facter
  package { $package_name:
    ensure => $package,
    notify => Service['puppet-agent'],
  }
}
