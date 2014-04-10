define accounts::authorized_key(
  $public_key = regsubst($name, '^(\S+)-on-\S+$', '\1'),
  $user       = regsubst($name, '^\S+-on-(\S+)$', '\1'),
) {
  validate_hash($::accounts::public_keys)

  ssh_authorized_key { "${public_key}-on-${user}":
    ensure => present,
    user   => $user,
    type   => $::accounts::public_keys[$public_key]['type'],
    key    => $::accounts::public_keys[$public_key]['key'],
  }
}
