# See README.md for details.
define accounts::account(
  $ensure                   = present,
  $comment                  = undef,
  $user                     = $name,
  $groups                   = [],
  $groups_membership        = $::accounts::groups_membership,
  $authorized_keys          = [],
  $authorized_keys_target   = undef,
  $purge_ssh_keys           = $::accounts::purge_ssh_keys,
  $ssh_authorized_key_title = $::accounts::ssh_authorized_key_title,
  $shell                    = $::accounts::shell,
  $home                     = undef,
  $password                 = undef,
  $uid                      = undef,
  $gid                      = undef,
  $ssh_options              = undef,
) {
  $account = $user # for strformat mapping...
  if $user =~ /^@(\S+)$/ {
    if ! has_key($::accounts::usergroups, $1) {
      fail "Can't find usergroup : ${1}"
    }
    ensure_resource(
      accounts::account,
      $::accounts::usergroups[$1],
      {
        ensure                   => $ensure,
        comment                  => $comment,
        groups                   => $groups,
        authorized_keys          => $authorized_keys,
        authorized_keys_target   => $authorized_keys_target,
        purge_ssh_keys           => $purge_ssh_keys,
        ssh_authorized_key_title => $ssh_authorized_key_title,
        shell                    => $shell,
        home                     => $home,
        password                 => $password,
        uid                      => $uid,
        gid                      => $gid,
      }
    )
  } else {
    if has_key($::accounts::users, $user) {
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
          groups     => $groups,
          home       => $_home,
          password   => $password,
          managehome => true,
          membership => $groups_membership,
          shell      => $shell,
          uid        => $uid,
          gid        => $gid,
        },
        $::accounts::users[$name]
      )

      if versioncmp($::puppetversion, '3.6.0') >= 0 {
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
      if is_string($authorized_keys) or is_array($authorized_keys) {
        $user_has_key = has_key($::accounts::ssh_keys, $name) and $::accounts::ssh_keys[$name]['ensure'] != 'absent'
        $_authorized_keys = $user_has_key ? {
          true  => suffix(unique( delete_undef_values( flatten( [$authorized_keys, $name] ) ) ),"-on-${name}"),
          false => suffix(unique( delete_undef_values( flatten( [$authorized_keys] ) ) ),"-on-${name}"),
        }
        accounts::authorized_key { $_authorized_keys:
          account                  => $name,
          options                  => $ssh_options,
          target                   => $authorized_keys_target,
          ssh_authorized_key_title => $ssh_authorized_key_title,
        }
      } elsif is_hash($authorized_keys) {
        $tmp_hash = merge({"${name}" => {},}, $authorized_keys)
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
      if $::accounts::ssh_keys[$name] != undef and $::accounts::ssh_keys[$name]['private'] != undef {
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
          command => "/bin/echo '${::accounts::ssh_keys[$name]['private']}' > ~${user}/.ssh/id_rsa; /bin/chown ${user} ~${user}/.ssh/id_rsa; /bin/chmod 600 ~${user}/.ssh/id_rsa",
          unless  => "/usr/bin/test -f ~${user}/.ssh/id_rsa",
        }
      }
    }

    if ! $purge_ssh_keys {
      $keys_to_remove = suffix(keys(absents($::accounts::ssh_keys)), "-on-${name}")
      accounts::authorized_key { $keys_to_remove:
        ensure                   => absent,
        account                  => $name,
        target                   => $authorized_keys_target,
        ssh_authorized_key_title => $ssh_authorized_key_title,
      }
    }
  }
}
