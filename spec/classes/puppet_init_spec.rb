require 'spec_helper'
require File.expand_path(File.dirname(__FILE__)) + '/../defines/parameters.rb'

@parameters.each { |os_key,os_values|
  describe 'puppet' do
    let :facts do 
      {:osfamily        => os_values['osfamily'], 
       :operatingsystem => os_values['operatingsystem']}
    end
  
    it { should contain_package('puppet').with(:ensure => 'installed') }
  end
}
describe 'puppet' do
  let :facts do 
    {:osfamily => 'NoFamily'}
  end
  
  it do
		expect{should compile}.to raise_error(Puppet::Error, /Module puppet is not supported on.*/)
	end
end
