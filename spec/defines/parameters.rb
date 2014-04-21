@parameters = {
  'Ubuntu' => {
    'osfamily'        => 'Debian',
    'operatingsystem' => 'Ubuntu',
    'master'          => {
      'package_name'            => 'puppetmaster',
      'sysconfig_file'          => '/etc/default/puppetmaster',
      'sysconfig_file_content'  => /DAEMON_OPTS="--config=\/etc\/puppet\/puppetmaster.conf"/
    },
    'agent'           => {
      'package_name'            => 'puppet',
      'service_name'            => 'puppet',
      'sysconfig_file'          => '/etc/default/puppet',
      'sysconfig_file_content'  => /DAEMON_OPTS="agent --environment=production --server=puppet"/
    }
  },
  'Fedora' => {
    'operatingsystem' => 'Fedora',
    'osfamily'        => 'RedHat',
    'master'          => {
      'package_name'            => 'puppet-server',
      'sysconfig_file'          => '/etc/sysconfig/puppetmaster',
      'sysconfig_file_content'  => /PUPPETMASTER_EXTRA_OPTS="--config=\/etc\/puppet\/puppetmaster.conf"/
    },
    'agent'           => {
      'package_name'            => 'puppet',
      'service_name'            => 'puppetagent',
      'sysconfig_file'          => '/etc/sysconfig/puppetagent',
      'sysconfig_file_content'  => /PUPPET_EXTRA_OPTS="--environment=production --server=puppet"/
    }
  },
  'CentOS' => {
    'operatingsystem' => 'CentOS',
    'osfamily'        => 'RedHat',
    'master'          => {
      'package_name'            => 'puppet-server',
      'service_name'            => 'puppet',
      'sysconfig_file'          => '/etc/sysconfig/puppetmaster',
      'sysconfig_file_content'  => /PUPPETMASTER_EXTRA_OPTS="--config=\/etc\/puppet\/puppetmaster.conf"/
    },
    'agent'           => {
      'package_name'            => 'puppet',
      'service_name'            => 'puppet',
      'sysconfig_file'          => '/etc/sysconfig/puppet',
      'sysconfig_file_content'  => /PUPPET_EXTRA_OPTS="--environment=production --server=puppet"/
    }
  }
}
