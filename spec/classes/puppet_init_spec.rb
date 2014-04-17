require 'spec_helper'

describe 'puppet' do
  let :facts do 
    {:osfamily => 'RedHat'}
  end
  
  it { should contain_package('puppet').with(:ensure => 'installed') }
end

describe 'puppet' do
  let :facts do 
    {:osfamily => 'NoFamily'}
  end
  
  it do
		expect{should compile}.to raise_error(Puppet::Error, /Module puppet is not supported on.*/)
	end
end
