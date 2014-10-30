require 'spec_helper'

describe 'accounts::account' do
  let(:title) { 'foo' }

  let(:facts) do
    {
      :osfamily => 'Debian',
    }
  end

  let(:pre_condition) do
    <<-EOS
class { 'accounts':
  ssh_keys => {
    foo => {
      type    => 'ssh-rsa',
      public  => 'FOO-S-RSA-PUBLIC-KEY',
      comment => 'foo@example.com',
    },
  },
  users    => {
    foo => {
      comment => 'Mr. Foo',
      uid     => 1000,
    },
  },
}
    EOS
  end

  context 'without param' do
    it { should compile.with_all_deps }
    it { should have_ssh_authorized_key_resource_count(1) }
    it { should contain_ssh_authorized_key('foo-on-foo').with({ :ensure => :present }) }
  end

  context 'when ssh_authorized_key_title => \'%{ssh_key} on %{user}\'' do
    let(:params) do
      {
        :ssh_authorized_key_title => '%{ssh_key} on %{user}',
      }
    end
    it { should compile.with_all_deps }
    it { should have_ssh_authorized_key_resource_count(1) }
    it { should contain_ssh_authorized_key('foo on foo').with({ :ensure => :present }) }
  end

  context 'when ssh_authorized_key_title => "%{ssh_keys[\'%{ssh_key}\'][\'comment\']} on %{user}"' do
    let(:params) do
      {
        :ssh_authorized_key_title => "%{ssh_keys['%{ssh_key}']['comment']} on %{user}",
      }
    end
    it { should compile.with_all_deps }
    it { should have_ssh_authorized_key_resource_count(1) }
    it { should contain_ssh_authorized_key('foo@example.com on foo').with({ :ensure => :present }) }
  end
end
