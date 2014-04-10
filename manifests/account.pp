define accounts::account {
  ensure_resource(
    'user',
    $name,
    delete($::accounts::users[$name], 'authorized_keys')
  )

  $authorized_keys = suffix(
    unique(
      delete_undef_values(
        flatten(
          [$::accounts::users[$name]['authorized_keys'], $name]
        )
      )
    ),
    "-on-${name}"
  )
  accounts::authorized_key { $authorized_keys:
    user => $name,
  }

  $keys_to_remove = suffix(keys(absents($::accounts::users)), "-on-${name}")
  ssh_authorized_key { $keys_to_remove:
    ensure => absent,
    user   => $name,
  }
}
