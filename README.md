Accounts
========

[![Build Status](https://travis-ci.org/camptocamp/puppet-accounts.png?branch=master)](https://travis-ci.org/camptocamp/puppet-accounts)

Usage
-----

```puppet
class { 'accounts':
  groups      => hiera_hash('accounts::groups'),
  public_keys => hiera_hash('accounts::public_keys'),
  users       => hiera_hash('accounts::users'),
  accounts    => hiera_hash('accounts::accounts'),
}
```

### common.yaml
```
---
accounts::public_keys:
  foo:
    type: ssh-rsa
    key: FOO-S-RSA-PUBLIC-KEY
  bar:
    type: ssh-rsa
    key: BAR-S-RSA-PUBLIC-KEY
accounts::users:
  foo:
    groups:
      - foo
    uid: 1000
    authorized_keys:
      - foo
      - bar
      - baz
  bar:
    groups:
      - foo
      - bar
      - baz
    uid: 1001
    authorized_keys:
      - bar
    system: true
  baz:
    ensure: absent
# Create foo and bar accounts on every node
accounts::accounts:
  - foo
  - bar
```

### foo.example.com.yaml
```
---
accounts::groups:
  foo:
    gid: 1000
  bar:
    system: true
accounts::public_keys:
  baz:
    type: ssh-rsa
    key: BAZ-S-RSA-PUBLIC-KEY
accounts::users:
  baz:
    groups:
      - foo
    uid: 1002
# Create baz accounts on foo.example.com.yaml only
accounts::accounts:
  - baz
```

### bar.example.com.yaml
```
---
accounts::public_keys:
  quux:
    type: ssh-rsa
    key: QUUX-S-RSA-PUBLIC-KEY
accounts::users:
  quux:
    groups:
      - quux
    uid: 1003
    authorized_keys:
      - quux
      - foo
# Create quux accounts on bar.example.com.yaml only
accounts::accounts:
  - quux
```
