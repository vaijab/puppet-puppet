# == Class: puppet::hiera::eyaml
#
# This class installs rubygem-hiera-eyaml package and allows
# key management.
#
# === Parameters
#
# See README.md
#
# === Requires
#
# None
#
# === Examples
#
# See README.md
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class puppet::hiera::eyaml(
  $package       = 'installed',
  $generate_keys = false,
) inherits puppet::master {
  case $::osfamily {
    RedHat: {
      $package_name = 'rubygem-hiera-eyaml'
    }
    Debian: {
      $package_name = 'rubygem-hiera-eyaml'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  $keys_dir    = '/etc/puppet/keys'
  $private_key = '/etc/puppet/keys/private_key.pem'
  $public_key  = '/etc/puppet/keys/public_key.pem'

  package { $package_name:
    ensure  => $package,
  }

  file { $keys_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'puppet',
    mode    => '0640',
    recurse => true,
  }

  if $generate_keys {
    exec { 'create_hiera_eyaml_keys':
      path    => '/usr/local/bin:/usr/bin',
      command => "eyaml -c --private-key ${private_key} --public-key ${public_key}",
      creates => $private_key,
      require => File[$keys_dir],
    }
  }
}
