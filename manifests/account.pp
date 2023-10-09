# See README.md for details.
# @param ensure [String] Whether the account should be present or absent.
# @param comment [String] A comment to be added to the account.
# @param user String The name of the user to manage.
# @param expiry [String] The date on which the account will be disabled.
# @param groups [Array[String]] The groups to which the user should belong.
# @param groups_membership [String] Whether to manage the user's group membership.
# @param authorized_keys [Array[String]] The SSH public keys to be added to the user's authorized_keys file.
# @param authorized_keys_target [String] The target file to which the authorized_keys should be written.
# @param purge_ssh_keys [Boolean] Whether to purge the authorized_keys file of keys not managed by Puppet.
# @param ssh_authorized_key_title [String] The title of the ssh_authorized_key resource.
# @param shell [String] The user's shell.
# @param home [String] The user's home directory.
# @param managehome [Boolean] Whether to manage the user's home directory.
# @param forcelocal [Boolean] Whether to force the user to be a local user.
# @param password [String] The user's password.
# @param uid [String] The user's UID.
# @param gid [String] The user's GID.
# @param system [String] Whether the user is a system user.
# @param ssh_options [String] The options to be added to the user's authorized_keys file.
define accounts::account (
  String $ensure                           = present,
  Optional[String] $comment                = undef,
  String $user                             = $name,
  Optional[String] $expiry                 = undef,
  Array[String] $groups                    = [],
  Optional[String] $groups_membership      = $accounts::groups_membership,
  Array[String] $authorized_keys           = [],
  Optional[String] $authorized_keys_target = undef,
  Boolean $purge_ssh_keys                  = $accounts::purge_ssh_keys,
  String $ssh_authorized_key_title         = $accounts::ssh_authorized_key_title,
  Optional[String] $shell                  = $accounts::shell,
  Optional[String] $home                   = undef,
  Boolean $managehome                      = $accounts::managehome,
  Boolean $forcelocal                      = $accounts::forcelocal,
  Optional[String] $password               = undef,
  Optional[String] $uid                    = undef,
  Optional[String] $gid                    = undef,
  Optional[String] $system                 = undef,
  Optional[String] $ssh_options            = undef,
) {
  $account = $user # for strformat mapping...
  if $user =~ /^@(\S+)$/ {
    if ! ( $1 in $accounts::usergroups ) {
      fail "Can't find usergroup : ${1}"
    }
    ensure_resource(
      accounts::account,
      $accounts::usergroups[$1],
      {
        ensure                   => $ensure,
        comment                  => $comment,
        groups                   => $groups,
        authorized_keys          => $authorized_keys,
        authorized_keys_target   => $authorized_keys_target,
        purge_ssh_keys           => $purge_ssh_keys,
        ssh_authorized_key_title => $ssh_authorized_key_title,
        forcelocal               => $forcelocal,
        shell                    => $shell,
        home                     => $home,
        password                 => $password,
        uid                      => $uid,
        gid                      => $gid,
        ssh_options              => $ssh_options,
        system                   => $system,
      }
    )
  } else {
    if ( $user in $accounts::users ) {
      if $purge_ssh_keys and $authorized_keys_target {
        $_purge_ssh_keys = strformat($authorized_keys_target)
      } else {
        $_purge_ssh_keys = $purge_ssh_keys
      }
      $_home = $home ? {
        undef   => "/home/${$user}",
        default => $home,
      }

      $hash = merge(
        {
          ensure     => $ensure,
          comment    => $comment,
          home       => $_home,
          password   => $password,
          managehome => $managehome,
          membership => $groups_membership,
          forcelocal => $forcelocal,
          shell      => $shell,
          uid        => $uid,
          gid        => $gid,
          expiry     => $expiry,
          system     => $system,
        },
        $accounts::users[$name],
        { groups => $groups.concat($accounts::users[$name][groups].pick([])).flatten.unique }
      )

      if versioncmp($facts['puppetversion'], '3.6.0') >= 0 {
        $_hash = merge(
          $hash,
          {
            purge_ssh_keys => $_purge_ssh_keys,
          }
        )
      } else {
        $_hash = $hash
      }
      ensure_resource(
        user,
        $user,
        $_hash
      )
    }
    if $ensure != absent {
      if ($authorized_keys =~ String) or ($authorized_keys =~ Array) {
        $user_has_key = ( $name in $accounts::ssh_keys ) and $accounts::ssh_keys[$name]['ensure'] != 'absent'
        $_authorized_keys = $user_has_key ? {
          true  => suffix(unique( delete_undef_values( flatten([$authorized_keys, $name]) ) ),"-on-${name}"),
          false => suffix(unique( delete_undef_values( flatten([$authorized_keys]) ) ),"-on-${name}"),
        }
        accounts::authorized_key { $_authorized_keys:
          account                  => $name,
          options                  => $ssh_options,
          target                   => $authorized_keys_target,
          ssh_authorized_key_title => $ssh_authorized_key_title,
        }
      } elsif ($authorized_keys =~ Hash) {
        $tmp_hash = merge({ "${name}" => {}, }, $authorized_keys)
        $_authorized_keys = hash(
          zip(suffix(keys($tmp_hash), "-on-${name}"), values($tmp_hash))
        )
        create_resources(
          accounts::authorized_key,
          $_authorized_keys,
          {
            options                  => $ssh_options,
            target                   => $authorized_keys_target,
            ssh_authorized_key_title => $ssh_authorized_key_title,
          }
        )
      } else {
        fail 'authorized_keys must be a String, an Array or a Hash'
      }
      if $accounts::ssh_keys[$name] != undef and $accounts::ssh_keys[$name]['private'] != undef {
        # NOTE: getparam(User[$user], 'home') would do the trick to fetch
        # user's home dir, but it depends on parsing order
        #
        # $home = getparam(User[$user], 'home')
        # file { "${home}/.ssh/id_rsa":
        #   content => $::accounts::ssh_keys[$name]['private'],
        # }
        #
        # Another solution would be to use puppetdbquery:
        #
        # $ret = query_resources("fqdn='${::fqdn}'", "User['${user}']")
        # $home = $ret[$::fqdn][0]['parameters']['home']
        #
        # TODO: Fix unless so that it replaces the key
        exec { "put ssh private key ${name} for user ${user}":
          command => "/bin/echo '${accounts::ssh_keys[$name]['private']}' > ~${user}/.ssh/id_rsa; /bin/chown ${user} ~${user}/.ssh/id_rsa; /bin/chmod 600 ~${user}/.ssh/id_rsa",
          unless  => "/usr/bin/test -f ~${user}/.ssh/id_rsa",
          onlyif  => "/usr/bin/test -d ~${user}/.ssh",
        }
      }
    }

    if ! $purge_ssh_keys or ! ( $user in $accounts::users ) {
      $keys_to_remove = suffix(keys(absents($accounts::ssh_keys)), "-on-${name}")
      accounts::authorized_key { $keys_to_remove:
        ensure                   => absent,
        account                  => $name,
        target                   => $authorized_keys_target,
        ssh_authorized_key_title => $ssh_authorized_key_title,
      }
    }
  }
}
