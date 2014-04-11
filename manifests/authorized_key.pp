define accounts::authorized_key(
  $public_key = regsubst($name, '^(\S+)-on-\S+$', '\1'),
  $user       = regsubst($name, '^\S+-on-(\S+)$', '\1'),
) {
  validate_hash($::accounts::public_keys)

  if $::accounts::public_keys[$public_key] != undef {
    ssh_authorized_key { "${public_key}-on-${user}":
      user   => $user,
      type   => $::accounts::public_keys[$public_key]['type'],
      key    => $::accounts::public_keys[$public_key]['key'],
    }
  }
}
