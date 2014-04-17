require 'spec_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../defines/parameters.rb'

@parameters.each { |os_key,os_values|
  describe 'puppet::master' do
    let :facts do 
      {:osfamily        => os_values['osfamily'], 
       :operatingsystem => os_values['operatingsystem']}
    end
  
    required_package_name = os_values['master']['package_name']
    required_package_decl = 'Package['+required_package_name+']'

    
    it { should contain_package(required_package_name).with(:ensure => 'installed') }
    it { should contain_package('puppetdb-terminus').with(:ensure => 'installed') }
    it { should contain_service('puppetmaster')
                  .with(:ensure => 'running',
                        :require => required_package_decl) 
    }
    it { should contain_file('/etc/puppet/puppetmaster.conf')
                  .with(:ensure => 'file',
                        :mode => '0640',
                        :owner => 'root',
                        :group => 'root',
                        :require => required_package_decl) 
    }
    it { should contain_file('/etc/puppet/hiera.yaml')
                  .with(:ensure => 'file',
                        :mode => '0644',
                        :owner => 'root',
                        :group => 'root',
                        :require => required_package_decl) 
    }
    it { should contain_file(os_values['master']['sysconfig_file'])
                    .with(:ensure => 'file',
                          :mode => '0644',
                          :owner => 'root',
                          :group => 'root',
                          :require => required_package_decl)
                    .with_content(os_values['master']['sysconfig_file_content'])
    }
  end
}