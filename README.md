Accounts
========

[![Build Status](https://travis-ci.org/camptocamp/puppet-accounts.png?branch=master)](https://travis-ci.org/camptocamp/puppet-accounts)

Usage
-----

```puppet
class { 'accounts':
  groups      => {
    'foo' => {
      gid => 1000,
    },
    'bar' => {
      system => true,
    }
  },
  public_keys => {
    'foo' => {
      type => 'ssh-rsa',
      key  => 'FOO-S-RSA-PUBLIC-KEY',
    },
    'bar' => {
      type => 'ssh-rsa',
      key  => 'BAR-S-RSA-PUBLIC-KEY',
    },
    'baz' => {
      type => 'ssh-rsa',
      key  => 'BAZ-S-RSA-PUBLIC-KEY',
    },
  }
  users       => {
    'foo' => {
      uid         => 1000,
      public_keys => [ 'foo', 'bar', 'baz', ],
    },
    'bar' => {
      uid         => 1001,
      public_keys => [ 'bar', ],
      system      => true,
    },
    'baz' => {
      ensure => absent,
    }
  }
}
```

or maybe:

```puppet
class { 'accounts':
  groups      => hiera_hash('accounts::groups'),
  public_keys => hiera_hash('accounts::public_keys'),
  users       => hiera_hash('accounts::users'),
}
```

and

```
---
accounts::groups:
  foo:
    gid: 1000
  bar:
    system: true
accounts::public_keys:
  foo:
    type: ssh-rsa
    key: FOO-S-RSA-PUBLIC-KEY
  bar:
    type: ssh-rsa
    key: BAR-S-RSA-PUBLIC-KEY
  baz:
    type: ssh-rsa
    key: BAZ-S-RSA-PUBLIC-KEY
accounts::users:
  foo:
    groups:
      - foo
    uid: 1000
    public_keys:
      - foo
      - bar
      - baz
  bar:
    groups:
      - foo
      - bar
      - baz
    uid: 1001
    public_keys:
      - bar
    system: true
  baz
    ensure: absent
```
