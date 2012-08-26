require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'vagrant' do

  let(:title) { 'vagrant' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('vagrant').with_ensure('present') }
    it { should_not contain_file('vagrant.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('vagrant').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :firewall => true , :config_file => '/etc/vagrant.conf' } }

    it 'should remove Package[vagrant]' do should contain_package('vagrant').with_ensure('absent') end 
    it 'should remove vagrant configuration file' do should contain_file('vagrant.conf').with_ensure('absent') end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :firewall => true , :config_file => '/etc/vagrant.conf' } }

    it { should contain_package('vagrant').with_ensure('present') }
    it { should contain_file('vagrant.conf').with_ensure('present') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true , :firewall => true} }
  
    it { should contain_package('vagrant').with_ensure('present') }
  end 

  describe 'Test customizations - template' do
    let(:params) { {:template => "vagrant/spec.erb" , :options => { 'opt_a' => 'value_a' } , :config_file => '/etc/vagrant.conf' } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', 'vagrant.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'vagrant.conf').send(:parameters)[:content]
      content.should match "value_a"
    end

  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/vagrant/spec" , :source_dir => "puppet://modules/vagrant/dir/spec" , :source_dir_purge => true , :config_file => '/etc/vagrant.conf' , :config_dir => '/etc/vagrant/' } }

    it 'should request a valid source ' do
      content = catalogue.resource('file', 'vagrant.conf').send(:parameters)[:source]
      content.should == "puppet://modules/vagrant/spec"
    end
    it 'should request a valid source dir' do
      content = catalogue.resource('file', 'vagrant.dir').send(:parameters)[:source]
      content.should == "puppet://modules/vagrant/dir/spec"
    end
    it 'should purge source dir if source_dir_purge is true' do
      content = catalogue.resource('file', 'vagrant.dir').send(:parameters)[:purge]
      content.should == true
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "vagrant::spec" , :config_file => '/etc/vagrant.conf' } }
    it 'should automatically include a custom class' do
      content = catalogue.resource('file', 'vagrant.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }

    it 'should generate a puppi::ze define' do
      content = catalogue.resource('puppi::ze', 'vagrant').send(:parameters)[:helper]
      content.should == "myhelper"
    end
  end

end

