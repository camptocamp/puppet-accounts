define accounts::account(
  $ensure          = undef,
  $user            = $name,
  $groups          = [],
  $authorized_keys = [],
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
    user { $name:
      ensure => $ensure,
      groups => $groups,
    }

    if $ensure != absent {
      $_authorized_keys = suffix(
        unique( delete_undef_values( flatten( [$authorized_keys, $name] ) ) ),
        "-on-${name}"
      )
      accounts::authorized_key { $_authorized_keys:
        user   => $name,
      }
    }

    $keys_to_remove = suffix(keys(absents($::accounts::public_keys)), "-on-${name}")
    ssh_authorized_key { $keys_to_remove:
      ensure => absent,
      user   => $name,
    }
  }
}
