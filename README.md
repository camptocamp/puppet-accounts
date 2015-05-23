Accounts
========

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/accounts.svg)](https://forge.puppetlabs.com/camptocamp/accounts)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/accounts.svg)](https://forge.puppetlabs.com/camptocamp/accounts)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-accounts/master.svg)](https://travis-ci.org/camptocamp/puppet-accounts)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppet-accounts.svg)](https://gemnasium.com/camptocamp/puppet-accounts)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)

Usage
-----

First, you have to declare your `ssh_keys`, `users` and `usergroups` hashes:

```puppet
class { 'accounts':
  ssh_keys   => hiera_hash('accounts::ssh_keys', {}),
  users      => hiera_hash('accounts::users', {}),
  usergroups => hiera_hash('accounts::usergroups', {}),
}
```

Example hiera YAML file:
```
---
accounts::ssh_keys:
  foo:
    type: ssh-rsa
    public: FOO-S-RSA-PUBLIC-KEY
  bar:
    type: ssh-rsa
    public: BAR-S-RSA-PUBLIC-KEY

accounts::users:
  foo:
    uid: 1000
    comment: Foo
  bar:
    uid: 1001
    comment: Bar
  baz:
    # Remove user baz from every node (unless overridden)
    ensure: absent
  qux:
    uid: 1003
    comment: Qux

accounts::usergroups:
  foo:
    - foo
    - bar
  bar:
    - baz
    - qux
```

Then you can create accounts on your node with the `accounts::account` defined type.

```puppet
accounts::account { 'foo': }
```
Creates a `foo` user if it exists in `$::accounts::users` and at allow its public key if it exists in `$::accounts::ssh_keys`.

```puppet
accounts::account { 'bar':
  authorized_keys => ['@foo', 'baz'],
}
```
Creates a `bar` user if it exists in `$::accounts::users` and at allow its public key, everyone's in the`foo` usergroup's public key and `baz`'s one if it exists in `$::accounts::ssh_keys`.

```puppet
accounts::account { '@foo': }
```
Create a user for every user in `foo` usergroup and allow its public key.
