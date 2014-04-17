require 'spec_helper'

describe 'puppet::master' do
  let :facts do 
    {:osfamily => 'RedHat'}
  end
  
  it { should contain_package('puppet-server').with(:ensure => 'installed') }
  it { should contain_package('puppetdb-terminus').with(:ensure => 'installed') }
  it { should contain_service('puppetmaster')
                .with(:ensure => 'running',
                      :require => 'Package[puppet-server]') 
  }
  it { should contain_file('/etc/puppet/puppetmaster.conf')
                .with(:ensure => 'file',
                      :mode => '0640',
                      :owner => 'root',
                      :group => 'root',
                      :require => 'Package[puppet-server]') 
  }
  it { should contain_file('/etc/puppet/hiera.yaml')
                .with(:ensure => 'file',
                      :mode => '0644',
                      :owner => 'root',
                      :group => 'root',
                      :require => 'Package[puppet-server]') 
  }
  it { should contain_file('/etc/sysconfig/puppetmaster')
                  .with(:ensure => 'file',
                        :mode => '0644',
                        :owner => 'root',
                        :group => 'root',
                        :require => 'Package[puppet-server]')
                  .with_content(/PUPPETMASTER_EXTRA_OPTS="--config=\/etc\/puppet\/puppetmaster.conf"/)
  }
end

describe 'puppet::master' do
  let :facts do 
    {:osfamily => 'Debian',:operatingsystem => 'Ubuntu'}
  end
  
  it { should contain_package('puppetmaster').with(:ensure => 'installed') }
  it { should contain_package('puppetdb-terminus').with(:ensure => 'installed') }
  it { should contain_service('puppetmaster')
                .with(:ensure => 'running',
                      :require => 'Package[puppetmaster]') 
  }
  it { should contain_file('/etc/default/puppetmaster')
                  .with(:ensure => 'file',
                        :mode => '0644',
                        :owner => 'root',
                        :group => 'root',
                        :require => 'Package[puppetmaster]')
                  .with_content(/DAEMON_OPTS="--config=\/etc\/puppet\/puppetmaster.conf"/)
  }
end
