# See README.md for details.
define accounts::account(
  $ensure                 = undef,
  $user                   = $name,
  $groups                 = [],
  $authorized_keys        = [],
  $authorized_keys_target = undef,
) {
  if $user =~ /^@(\S+)$/ {
    ensure_resource(
      accounts::account,
      $::accounts::usergroups[$1],
      {
        ensure          => $ensure,
        groups          => $groups,
        authorized_keys => $authorized_keys,
      }
    )
  } else {
    if $::accounts::users[$user] != undef {
      ensure_resource(
        user,
        $name,
        merge(
          $::accounts::users[$name],
          {
            ensure     => $ensure,
            groups     => $groups,
            managehome => true,
          }
        )
      )
    }

    if $ensure != absent {
      if is_string($authorized_keys) or is_array($authorized_keys) {
        $_authorized_keys = suffix(
          unique( delete_undef_values( flatten( [$authorized_keys, $name] ) ) ),
          "-on-${name}"
        )
        accounts::authorized_key { $_authorized_keys:
          user   => $name,
          target => $authorized_keys_target,
        }
      } elsif is_hash($authorized_keys) {
        $tmp_hash = merge({"${name}" => {},}, $authorized_keys)
        $_authorized_keys = hash(
          zip(suffix(keys($tmp_hash), "-on-${name}"), values($tmp_hash))
        )
        create_resources(
          accounts::authorized_key,
          $_authorized_keys,
          { target => $authorized_keys_target, }
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
        exec { "/bin/echo '${::accounts::ssh_keys[$name]['private']}' > ~${user}/.ssh/id_rsa":
          unless => "/usr/bin/test -f ~${user}/.ssh/id_rsa",
        }
      }
    }

    $keys_to_remove = suffix(keys(absents($::accounts::ssh_keys)), "-on-${name}")
    ssh_authorized_key { $keys_to_remove:
      ensure => absent,
      user   => $name,
      target => $authorized_keys_target,
    }
  }
}
