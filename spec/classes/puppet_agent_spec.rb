require 'spec_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../defines/parameters.rb'

@parameters.each { |os_key,os_values|
  describe 'puppet::agent' do
    let :facts do 
      {:osfamily        => os_values['osfamily'], 
       :operatingsystem => os_values['operatingsystem']}
    end
  
    required_package_name = os_values['agent']['package_name']
    required_package_decl = 'Package['+required_package_name+']'
    service_name = os_values['agent']['service_name']
  
    it { should contain_package(required_package_name).with(:ensure => 'installed') }
    it { should contain_service(service_name).with(:ensure => 'running') }
    it { should contain_file(os_values['agent']['sysconfig_file'])
 								.with(:mode => '0644',:owner => 'root',:group => 'root')
  							.with_content(os_values['agent']['sysconfig_file_content']) 	
  	}
    it { should contain_file('/etc/puppet/puppet.conf').with(:mode => '0640',:owner => 'root',:group => 'root')}
  end
}

describe 'puppet::agent' do
  let :facts do 
    {
			:osfamily => 'RedHat',
    	:operatingsystem => 'NoneOS'
		}
  end

	it do
		expect{should compile}.to raise_error(Puppet::Error, /This class is not supported on your OS./)
	end
end