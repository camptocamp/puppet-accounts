<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [2.0.1](https://github.com/camptocamp/puppet-accounts/tree/2.0.1) - 2023-10-11

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/2.0.0...2.0.1)

### Other

- ⬆️ Deprecate has_key [#70](https://github.com/camptocamp/puppet-accounts/pull/70) ([JGodin-C2C](https://github.com/JGodin-C2C))

## [2.0.0](https://github.com/camptocamp/puppet-accounts/tree/2.0.0) - 2023-10-11

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.11.1...2.0.0)

### Other

- ⬆️ Deprecate has_key [#70](https://github.com/camptocamp/puppet-accounts/pull/70) ([JGodin-C2C](https://github.com/JGodin-C2C))
- Fix pull #66 again after pull #56 was merged [#68](https://github.com/camptocamp/puppet-accounts/pull/68) ([erik-frontify](https://github.com/erik-frontify))

## [1.11.1](https://github.com/camptocamp/puppet-accounts/tree/1.11.1) - 2019-07-30

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.11.0...1.11.1)

## [1.11.0](https://github.com/camptocamp/puppet-accounts/tree/1.11.0) - 2019-07-30

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.10.0...1.11.0)

### Other

- Allow ssh_options for accounts being created through accounts::usergr… [#66](https://github.com/camptocamp/puppet-accounts/pull/66) ([erik-frontify](https://github.com/erik-frontify))
- Merge group arrays instead of rightmost precedence [#65](https://github.com/camptocamp/puppet-accounts/pull/65) ([kobybr](https://github.com/kobybr))
- Use loop instead of recursion [#64](https://github.com/camptocamp/puppet-accounts/pull/64) ([seidler2547](https://github.com/seidler2547))
- Fixes #61 - Pass through managehome on absent [#62](https://github.com/camptocamp/puppet-accounts/pull/62) ([edestecd](https://github.com/edestecd))
- Update to add the system option to account.pp [#60](https://github.com/camptocamp/puppet-accounts/pull/60) ([mooresm1](https://github.com/mooresm1))
- Correcting issue #15 [#56](https://github.com/camptocamp/puppet-accounts/pull/56) ([jschaeff](https://github.com/jschaeff))
- added expiry parameter [#55](https://github.com/camptocamp/puppet-accounts/pull/55) ([cjeanneret](https://github.com/cjeanneret))
- Add additional prerequisite [#53](https://github.com/camptocamp/puppet-accounts/pull/53) ([trevharmon](https://github.com/trevharmon))
- Fix puppet error if the account is not yet created [#41](https://github.com/camptocamp/puppet-accounts/pull/41) ([Zophar78](https://github.com/Zophar78))

## [1.10.0](https://github.com/camptocamp/puppet-accounts/tree/1.10.0) - 2018-01-03

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.9.3...1.10.0)

## [1.9.3](https://github.com/camptocamp/puppet-accounts/tree/1.9.3) - 2017-05-26

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.9.2...1.9.3)

## [1.9.2](https://github.com/camptocamp/puppet-accounts/tree/1.9.2) - 2017-05-22

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.9.1...1.9.2)

### Other

- Remove now unsupported "pe" requirement [#52](https://github.com/camptocamp/puppet-accounts/pull/52) ([dabelenda](https://github.com/dabelenda))

## [1.9.1](https://github.com/camptocamp/puppet-accounts/tree/1.9.1) - 2017-03-31

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.9.0...1.9.1)

### Other

- Force managing local users. [#45](https://github.com/camptocamp/puppet-accounts/pull/45) ([dabelenda](https://github.com/dabelenda))

## [1.9.0](https://github.com/camptocamp/puppet-accounts/tree/1.9.0) - 2017-01-10

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.8.1...1.9.0)

### Other

- delete .travis.yml.swp [#39](https://github.com/camptocamp/puppet-accounts/pull/39) ([igalic](https://github.com/igalic))

## [1.8.1](https://github.com/camptocamp/puppet-accounts/tree/1.8.1) - 2016-06-20

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.8.0...1.8.1)

## [1.8.0](https://github.com/camptocamp/puppet-accounts/tree/1.8.0) - 2016-02-18

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.7.0...1.8.0)

### Other

- parameterize managehome instead of hardcoding to true [#21](https://github.com/camptocamp/puppet-accounts/pull/21) ([mmckinst](https://github.com/mmckinst))

## [1.7.0](https://github.com/camptocamp/puppet-accounts/tree/1.7.0) - 2015-11-12

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.6.0...1.7.0)

### Other

- Allow to set options to ssh_authorized_key [#24](https://github.com/camptocamp/puppet-accounts/pull/24) ([mcanevet](https://github.com/mcanevet))

## [1.6.0](https://github.com/camptocamp/puppet-accounts/tree/1.6.0) - 2015-10-19

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.5.1...1.6.0)

### Other

- Don't create absent ssh_authorized_key resources if purge_ssh_keys is… [#22](https://github.com/camptocamp/puppet-accounts/pull/22) ([mcanevet](https://github.com/mcanevet))
- Add ability to set a password hash for a user. Undef = !. [#18](https://github.com/camptocamp/puppet-accounts/pull/18) ([johnzimm](https://github.com/johnzimm))
- Add uid and gid params to accounts::account [#14](https://github.com/camptocamp/puppet-accounts/pull/14) ([mcanevet](https://github.com/mcanevet))

## [1.5.1](https://github.com/camptocamp/puppet-accounts/tree/1.5.1) - 2015-08-21

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.5.0...1.5.1)

## [1.5.0](https://github.com/camptocamp/puppet-accounts/tree/1.5.0) - 2015-07-15

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.4.0...1.5.0)

## [1.4.0](https://github.com/camptocamp/puppet-accounts/tree/1.4.0) - 2015-07-02

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.3.5...1.4.0)

### Other

- Allow setting default user shell [#17](https://github.com/camptocamp/puppet-accounts/pull/17) ([ckaenzig](https://github.com/ckaenzig))

## [1.3.5](https://github.com/camptocamp/puppet-accounts/tree/1.3.5) - 2015-06-26

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.3.4...1.3.5)

## [1.3.4](https://github.com/camptocamp/puppet-accounts/tree/1.3.4) - 2015-05-28

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.3.3...1.3.4)

## [1.3.3](https://github.com/camptocamp/puppet-accounts/tree/1.3.3) - 2015-05-26

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.3.2...1.3.3)

## [1.3.2](https://github.com/camptocamp/puppet-accounts/tree/1.3.2) - 2015-05-26

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.3.1...1.3.2)

## [1.3.1](https://github.com/camptocamp/puppet-accounts/tree/1.3.1) - 2015-05-25

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.3.0...1.3.1)

## [1.3.0](https://github.com/camptocamp/puppet-accounts/tree/1.3.0) - 2015-05-22

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.2.2...1.3.0)

### Other

- Add support for user comment [#13](https://github.com/camptocamp/puppet-accounts/pull/13) ([mcanevet](https://github.com/mcanevet))
- Fix User resource title when $user != $name [#12](https://github.com/camptocamp/puppet-accounts/pull/12) ([mcanevet](https://github.com/mcanevet))

## [1.2.2](https://github.com/camptocamp/puppet-accounts/tree/1.2.2) - 2015-05-13

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.2.1...1.2.2)

## [1.2.1](https://github.com/camptocamp/puppet-accounts/tree/1.2.1) - 2015-05-12

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.2.0...1.2.1)

## [1.2.0](https://github.com/camptocamp/puppet-accounts/tree/1.2.0) - 2015-05-07

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.11...1.2.0)

### Other

- Default users 'membership' to 'inclusive' [#11](https://github.com/camptocamp/puppet-accounts/pull/11) ([ckaenzig](https://github.com/ckaenzig))

## [1.1.11](https://github.com/camptocamp/puppet-accounts/tree/1.1.11) - 2015-04-27

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.10...1.1.11)

### Other

- making sure the file is owned by user and not root. +the file permissions are 600 and not 444 [#8](https://github.com/camptocamp/puppet-accounts/pull/8) ([pankajagarwal](https://github.com/pankajagarwal))

## [1.1.10](https://github.com/camptocamp/puppet-accounts/tree/1.1.10) - 2015-04-03

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.9...1.1.10)

## [1.1.9](https://github.com/camptocamp/puppet-accounts/tree/1.1.9) - 2015-03-24

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.8...1.1.9)

## [1.1.8](https://github.com/camptocamp/puppet-accounts/tree/1.1.8) - 2015-02-24

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.7...1.1.8)

### Other

- Fix when using puppet < 3.6.0 [#5](https://github.com/camptocamp/puppet-accounts/pull/5) ([mcanevet](https://github.com/mcanevet))

## [1.1.7](https://github.com/camptocamp/puppet-accounts/tree/1.1.7) - 2015-01-05

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.6...1.1.7)

## [1.1.6](https://github.com/camptocamp/puppet-accounts/tree/1.1.6) - 2014-12-18

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.4...1.1.6)

## [1.1.4](https://github.com/camptocamp/puppet-accounts/tree/1.1.4) - 2014-12-18

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.3...1.1.4)

## [1.1.3](https://github.com/camptocamp/puppet-accounts/tree/1.1.3) - 2014-12-16

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.2...1.1.3)

### Other

- Change exec resource name when creating RSA private key [#3](https://github.com/camptocamp/puppet-accounts/pull/3) ([saimonn](https://github.com/saimonn))

## [1.1.2](https://github.com/camptocamp/puppet-accounts/tree/1.1.2) - 2014-11-17

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.1...1.1.2)

## [1.1.1](https://github.com/camptocamp/puppet-accounts/tree/1.1.1) - 2014-11-04

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.1.0...1.1.1)

## [1.1.0](https://github.com/camptocamp/puppet-accounts/tree/1.1.0) - 2014-10-30

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.0.2...1.1.0)

## [1.0.2](https://github.com/camptocamp/puppet-accounts/tree/1.0.2) - 2014-10-28

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/camptocamp/puppet-accounts/tree/1.0.1) - 2014-10-20

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/0.1.0...1.0.1)

## [0.1.0](https://github.com/camptocamp/puppet-accounts/tree/0.1.0) - 2014-09-05

[Full Changelog](https://github.com/camptocamp/puppet-accounts/compare/1a982d7ed18d357823a1e7ed2591ab6308692244...0.1.0)
