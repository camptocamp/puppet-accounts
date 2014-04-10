require 'spec_helper'

describe 'accounts' do

  context 'with no parameters' do
    it { should compile.with_all_deps }
  end

  context 'whith groups' do
    let(:params) do
      {
        :groups => {
          'foo' => {},
          'bar' => {},
        },
      }
    end
    it { should compile.with_all_deps }
    it { should contain_group('foo') }
    it { should contain_group('bar') }
  end

  context 'with public_keys' do
    let(:params) do
      {
        :public_keys => {
          'foo' => {
            'type' => 'ssh-rsa',
            'key'  => 'FOO-S-RSA-PUBLIC-KEY',
          },
          'bar' => {
            'type' => 'ssh-rsa',
            'key'  => 'BAR-S-RSA-PUBLIC-KEY',
          },
        },
      }
    end
    it { should compile.with_all_deps }
  end

  context 'with users' do
    let(:params) do
      {
        :public_keys => {
          'foo' => {
            'type' => 'ssh-rsa',
            'key'  => 'FOO-S-RSA-PUBLIC-KEY',
          },
          'bar' => {
            'type' => 'ssh-rsa',
            'key'  => 'BAR-S-RSA-PUBLIC-KEY',
          },
          'baz' => {
            'type' => 'ssh-rsa',
            'key'  => 'BAZ-S-RSA-PUBLIC-KEY',
          },
        },
        :users => {
          'foo' => {
            'uid'         => 1000,
            'public_keys' => [ 'foo', 'bar', 'baz', ],
          },
          'bar' => {
            'uid'         => 1001,
            'public_keys' => [ 'bar', ],
          },
        },
      }
    end
    it { should compile.with_all_deps }

    it { should contain_user('foo') }
    it { should contain_ssh_authorized_key('foo-on-foo').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('bar-on-foo').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('baz-on-foo').with({
      :ensure => :present,
    }) }
    
    it { should contain_user('bar') }
    it { should contain_ssh_authorized_key('foo-on-bar').with({
      :ensure => :absent,
    }) }
    it { should contain_ssh_authorized_key('bar-on-bar').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('baz-on-bar').with({
      :ensure => :absent,
    }) }

    it { should_not contain_user('baz') }
  end

end
