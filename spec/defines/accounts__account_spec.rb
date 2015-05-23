require 'spec_helper'

describe 'accounts::account' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :puppetversion => Puppet.version,
        })
      end

      let(:pre_condition) do
        <<-EOS
class { 'accounts':
  ssh_keys   => {
    'luke'   => {
      'type' => 'ssh-rsa',
      'public'  => "Luke's_Key",
    },
    'nigel'  => {
      'type' => 'ssh-rsa',
      'public'  => "Nigel's_Key",
    },
    'bill'   => {
      'type' => 'ssh-rsa',
      'public'  => "Bill's_Key",
    },
    'puneet' => {
      'type' => 'ssh-rsa',
      'public'  => "Puneet's_Key",
    },
    'kevin'  => {
      'type' => 'ssh-rsa',
      'public'  => "Kevin's_Key",
    },
    'raghu'  => {
      'type' => 'ssh-rsa',
      'public'  => "Raghu's_Key",
    },
    'kenny'  => {
      'type' => 'ssh-rsa',
      'public'  => "Kenny's_Key",
    },
    'karim'  => {
      'type' => 'ssh-rsa',
      'public'  => "Karim's_Key",
    },
    'phil'  => {
      'type' => 'ssh-rsa',
      'public'  => "Phil's_Key",
    },
    'beth'  => {
      'type' => 'ssh-rsa',
      'public'  => "Beth's_Key",
    },
    'sharmila'  => {
      'type' => 'ssh-rsa',
      'public'  => "Sharmila's_Key",
    },
    'ankou'   => {
      'ensure' => 'absent',
      'type'   => 'ssh-rsa',
      'public'    => "An_Ankou's_Key",
    }
  },
  users      => {
    'luke' => {
      'comment' => 'Luke K.',
      'uid'     => 1000,
    },
    'nigel' => {
      'comment' => 'Nigel K.',
      'uid'     => 1001,
    },
    'bill'  => {
      'comment' => 'Bill K.',
      'uid'     => 1002,
    },
    'puneet'  => {
      'comment' => 'Puneet A.',
      'uid'     => 1003,
    },
    'kevin'  => {
      'comment' => 'Kevin C.',
      'uid'     => 1004,
    },
    'raghu'  => {
      'comment' => 'Raghu R.',
      'uid'     => 1005,
    },
    'kenny'  => {
      'comment' => 'Kenny V.Z.',
      'uid'     => 1006,
    },
    'karim'  => {
      'comment' => 'Karim F.',
      'uid'     => 1007,
    },
    'phil'  => {
      'comment' => 'Phil K.',
      'uid'     => 1008,
    },
    'matt'  => {
      'comment' => 'Matt M.',
      'uid'     => 1009,
    },
  },
  usergroups => {
    'management' => [ 'luke', 'nigel', 'bill', ],
    'directors'  => [ 'puneet', 'kevin', 'luke', 'raghu', 'kenny', ],
    'observers'  => [ 'karim', 'phil', 'matt', ],
    'advisors'   => [ 'beth', 'sharmila', ],
  },
}
        EOS
      end

      context 'when no user or key' do
        let(:title) { 'foo' }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(0) }
        it { is_expected.to have_ssh_authorized_key_resource_count(1) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-foo').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'foo',
        })}
      end

      context 'when user but no key' do
        let(:title) { 'matt' }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(1) }
        it { is_expected.to contain_user('matt').with({
          :name           => 'matt',
          :ensure         => 'present',
          :comment        => 'Matt M.',
          :groups         => [],
          :home           => '/home/matt',
          :managehome     => true,
          :uid            => 1009,
        })}
        it { is_expected.to have_ssh_authorized_key_resource_count(1) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-matt').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'matt',
        })}
      end

      context 'when key but no user' do
        let(:title) { 'beth' }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(0) }
        it { is_expected.to have_ssh_authorized_key_resource_count(2) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-beth').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'beth',
        })}
        it { is_expected.to contain_ssh_authorized_key('beth-on-beth').with({
          :ensure => 'present',
          :key    => "Beth's_Key",
          :type   => 'ssh-rsa',
          :user   => 'beth',
        })}
      end

      context 'when user and key' do
        let(:title) { 'luke' }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(1) }
        it { is_expected.to contain_user('luke').with({
          :name           => 'luke',
          :ensure         => 'present',
          :comment        => 'Luke K.',
          :groups         => [],
          :home           => '/home/luke',
          :managehome     => true,
          :uid            => 1000,
        })}
        it { is_expected.to have_ssh_authorized_key_resource_count(2) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-luke').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'luke',
        })}
        it { is_expected.to contain_ssh_authorized_key('luke-on-luke').with({
          :ensure => 'present',
          :key    => "Luke's_Key",
          :type   => 'ssh-rsa',
          :user   => 'luke',
        })}
      end

      context "when adding Luke to root's authorized_keys" do
        let(:title) { 'root' }
        let(:params) {{
          :authorized_keys => 'luke',
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(0) }
        it { is_expected.to have_ssh_authorized_key_resource_count(2) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-root').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'root',
        })}
        it { is_expected.to contain_ssh_authorized_key('luke-on-root').with({
          :ensure => 'present',
          :key    => "Luke's_Key",
          :type   => 'ssh-rsa',
          :user   => 'root',
        })}
      end

      context "when adding @management to root's authorized_keys" do
        let(:title) { 'root' }
        let(:params) {{
          :authorized_keys => '@management',
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(0) }
        it { is_expected.to have_ssh_authorized_key_resource_count(4) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-root').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'root',
        })}
        it { is_expected.to contain_ssh_authorized_key('luke-on-root').with({
          :ensure => 'present',
          :key    => "Luke's_Key",
          :type   => 'ssh-rsa',
          :user   => 'root',
        })}
        it { is_expected.to contain_ssh_authorized_key('nigel-on-root').with({
          :ensure => 'present',
          :key    => "Nigel's_Key",
          :type   => 'ssh-rsa',
          :user   => 'root',
        })}
        it { is_expected.to contain_ssh_authorized_key('bill-on-root').with({
          :ensure => 'present',
          :key    => "Bill's_Key",
          :type   => 'ssh-rsa',
          :user   => 'root',
        })}
      end

      context 'when creating accounts for @management' do
        let(:title) { '@management' }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(3) }
        it { is_expected.to contain_user('luke').with({
          :name           => 'luke',
          :ensure         => 'present',
          :comment        => 'Luke K.',
          :groups         => [],
          :home           => '/home/luke',
          :managehome     => true,
          :uid            => 1000,
        })}
        it { is_expected.to contain_user('nigel').with({
          :name           => 'nigel',
          :ensure         => 'present',
          :comment        => 'Nigel K.',
          :groups         => [],
          :home           => '/home/nigel',
          :managehome     => true,
          :uid            => 1001,
        })}
        it { is_expected.to contain_user('bill').with({
          :name           => 'bill',
          :ensure         => 'present',
          :comment        => 'Bill K.',
          :groups         => [],
          :home           => '/home/bill',
          :managehome     => true,
          :uid            => 1002,
        })}
        it { is_expected.to have_ssh_authorized_key_resource_count(6) }
        it { is_expected.to contain_ssh_authorized_key('ankou-on-luke').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'luke',
        })}
        it { is_expected.to contain_ssh_authorized_key('luke-on-luke').with({
          :ensure => 'present',
          :key    => "Luke's_Key",
          :type   => 'ssh-rsa',
          :user   => 'luke',
        })}
        it { is_expected.to contain_ssh_authorized_key('ankou-on-nigel').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'nigel',
        })}
        it { is_expected.to contain_ssh_authorized_key('nigel-on-nigel').with({
          :ensure => 'present',
          :key    => "Nigel's_Key",
          :type   => 'ssh-rsa',
          :user   => 'nigel',
        })}
        it { is_expected.to contain_ssh_authorized_key('ankou-on-bill').with({
          :ensure => 'absent',
          :key    => "An_Ankou's_Key",
          :type   => 'ssh-rsa',
          :user   => 'bill',
        })}
        it { is_expected.to contain_ssh_authorized_key('bill-on-bill').with({
          :ensure => 'present',
          :key    => "Bill's_Key",
          :type   => 'ssh-rsa',
          :user   => 'bill',
        })}
      end
    end
  end
end
