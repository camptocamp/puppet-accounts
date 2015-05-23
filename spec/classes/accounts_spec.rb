require 'spec_helper'

describe 'accounts' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :puppetversion => Puppet.version,
        })
      end

      context 'with no parameters' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'when removing a user' do
        let(:params) {{
          :users    => {
            'luke'     => {
              'comment' => 'Luke K.',
              'uid'     => 1000,
            },
            'ankou' => {
              'ensure'  => 'absent',
              'comment' => 'An Ankou',
              'uid'     => 9999,
            },
          },
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_user_resource_count(1) }
        it { is_expected.to contain_user('ankou').with({
          :name   => 'ankou',
          :ensure => 'absent',
        })}
      end
    end
  end
end
