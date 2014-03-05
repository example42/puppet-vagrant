require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'vagrant::install' do

  let(:title) { 'vagrant::install' }
  let(:node) { 'rspec.example42.com' }

  describe 'Test installation as a gem' do
    let(:facts) { { :ipaddress => '10.42.42.42', :vagrant_install => 'gem' } }
    it { should contain_package('vagrant').with_provider('gem') }
  end

  describe 'Test installation as a package' do
    let(:facts) { { :ipaddress => '10.42.42.42', :vagrant_install => 'package' } }
    it { should contain_package('vagrant').without_provider('gem') }
  end
end
