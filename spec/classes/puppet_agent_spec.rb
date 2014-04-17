require 'spec_helper'

describe 'puppet::agent' do
  let :facts do 
    {
			:osfamily => 'RedHat',
    	:operatingsystem => 'CentOS'
		}
  end
  
  it { should contain_package('puppet').with(:ensure => 'installed') }
  it { should contain_service('puppet').with(:ensure => 'running') }
  it { should contain_file('/etc/sysconfig/puppet')
								.with(:mode => '0644',:owner => 'root',:group => 'root')
								.with_content(/PUPPET_EXTRA_OPTS="--environment=production --server=puppet"/) 	
	}
  it { should contain_file('/etc/puppet/puppet.conf').with(:mode => '0640',:owner => 'root',:group => 'root')}
end

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
