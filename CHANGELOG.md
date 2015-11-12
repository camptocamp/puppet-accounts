## 2015-11-12 - Release 1.7.0

Allow to set options to ssh_authorized_key

## 2015-10-19 - Release 1.6.0

Add ability to set a password hash for a user
Add uid and gid params to accounts::account
Don't create absent ssh_authorized_key resources if purge_ssh_keys is enabled

## 2015-08-21 - Release 1.5.1

Use docker for acceptance tests

## 2015-07-15 - Release 1.5.0

Add home parameter

## 2015-07-02 - Release 1.4.0

Add shell parameter

## 2015-06-26 - Release 1.3.5

Fix strict_variables activation with rspec-puppet 2.2

## 2015-05-28 - Release 1.3.4

Add beaker_spec_helper to Gemfile

## 2015-05-26 - Release 1.3.3

Use random application order in nodeset

## 2015-05-26 - Release 1.3.2

add utopic & vivid nodesets

## 2015-05-25 - Release 1.3.1

Don't allow failure on Puppet 4

## 2015-05-22 - Release 1.3.0

Fix User resource title when $user != $name
purge_ssh_key is actually supported in 3.6.0
Add support for user comment

## 2015-05-13 - Release 1.2.2

Add puppet-lint-file_source_rights-check gem

## 2015-05-12 - Release 1.2.1

Don't pin beaker

## 2015-05-07 - Release 1.2.0

Add support for changing users default membership

## 2015-04-27 - Release 1.1.11

Add nodeset ubuntu-12.04-x86_64-openstack

## 2015-04-03 - Release 1.1.10

Confine rspec pinning to ruby 1.8

## 2015-03-24 - Release 1.1.9

Various spec improvements

## 2015-02-24 - Release 1.1.8

purge_ssh_keys was alwaus set to false...
don't use purge_ssh_keys when puppet version < 3.6
Update unit tests
Update meta files

## 2015-01-05 - Release 1.1.7

Use CHANGELOG.md
Simplify bundler cache in Travis CI
Fix license name in metadata.json

## 2014-12-16 - Release 1.1.3

Fix exec resource name
Fix unit tests

## 2014-11-17 - Release 1.1.2

Lint metadata.json

## 2014-11-04 - Release 1.1.1

Fix when no target
Fix when purging with no target
Inverse hashes order in merge so that we can override params in hiera
Set user to root when using a target
Allow string formating for target
Forward authorized_keys_target and purge_ssh_keys when using usergroups

## 2014-10-28 - Release 1.1.0

Add purge-ssh-key support
Remove puppet < 3.6 support

## 2014-10-28 - Release 1.0.2

Fix an issue when using ssh_authorized_key_title and usergroup
Fix an issue when adding a user without ssh key defined

## 2014-10-20 - Release 1.0.1

Really setup automatic Forge release

## 2014-10-20 - Release 1.0.0

Setup automatic Forge releases
