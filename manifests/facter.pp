# == Class: puppet::facter
#
# This class installs facter
#
# === Parameters
#
# See README.md
#
# === Authors
#
# - Jonas Genannt <jonas@brachium-system.net>
#
class puppet::facter(
    $package = 'installed',
  ) {

  case $::osfamily {
    'RedHat': {
      $package_name = 'facter'
    }
    'Debian': {
      $package_name = 'facter'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  package { $package_name:
    ensure => $package,
  }
}
