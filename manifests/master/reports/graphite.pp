# == Class: puppet::master::reports::graphite
#
# This class configures puppet report processor for graphite.
#
# === Parameters
#
# See README.md
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class puppet::master::reports::graphite(
  $endpoint = undef,
  $prefix   = undef,
  $port     = '2003',
) inherits puppet::master {

  $config_file   = '/etc/puppet/graphite.yaml'
  $conf_template = 'graphite.yaml.erb'

  if $endpoint == 'undef' {
    fail('Graphite endpoint must be specified for reporting to work.')
  }

  file { $config_file:
    ensure  => file,
    require => Package[$puppet::package_name],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/${conf_template}"),
  }
}
