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

  context 'without accounts' do
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
          'quux' => {
            'type' => 'ssh-rsa',
            'key'  => 'QUUX-S-RSA-PUBLIC-KEY',
          },
        },
        :users => {
          'foo' => {
            'groups'          => [ 'foo', ],
            'uid'             => 1000,
            'authorized_keys' => [ 'foo', 'bar', 'baz', ],
          },
          'bar' => {
            'groups'          => [ 'foo', 'bar', 'baz', ],
            'uid'             => 1001,
            'authorized_keys' => [ 'bar', ],
          },
          'baz' => {
            'groups'          => [ 'baz', ],
            'uid'             => 1002,
            'authorized_keys' => [ 'baz', ],
          },
          'quux' => {
            'groups' => [ 'quux', ],
            'uid'    => 1003,
          },
        },
      }
    end
    it { should compile.with_all_deps }

    it { should have_user_resource_count(0) }
    it { should have_authorized_key_resource_count(0) }
  end

  context 'with accounts' do
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
          'quux' => {
            'type' => 'ssh-rsa',
            'key'  => 'QUUX-S-RSA-PUBLIC-KEY',
          },
        },
        :users => {
          'foo' => {
            'groups'          => [ 'foo', ],
            'uid'             => 1000,
            'authorized_keys' => [ 'bar', 'baz', ],
          },
          'bar' => {
            'groups'          => [ 'foo', 'bar', 'baz', ],
            'uid'             => 1001,
          },
          'baz' => {
            'groups'          => [ 'baz', ],
            'uid'             => 1002,
          },
          'quux' => {
            'groups' => [ 'quux', ],
            'uid'    => 1003,
          },
        },
	:accounts => [ 'foo', 'bar', ],
      }
    end
    it { should compile.with_all_deps }

    it { should have_ssh_authorized_key_resource_count(8) }

    it { should contain_user('foo').with({
      :groups => [ 'foo' ],
      :uid    => 1000,
    }) }
    it { should contain_ssh_authorized_key('foo-on-foo').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('bar-on-foo').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('baz-on-foo').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('quux-on-foo').with({
      :ensure => :absent,
    }) }

    it { should contain_user('bar').with({
      :groups => [ 'foo', 'bar', 'baz', ],
      :uid    => 1001,
    }) }
    it { should contain_ssh_authorized_key('foo-on-bar').with({
      :ensure => :absent,
    }) }
    it { should contain_ssh_authorized_key('bar-on-bar').with({
      :ensure => :present,
    }) }
    it { should contain_ssh_authorized_key('baz-on-bar').with({
      :ensure => :absent,
    }) }
    it { should contain_ssh_authorized_key('quux-on-bar').with({
      :ensure => :absent,
    }) }

    it { should_not contain_user('baz') }
    it { should_not contain_user('quux') }

  end

end
