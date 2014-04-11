define accounts::authorized_key(
  $public_key = regsubst($name, '^(\S+)-on-\S+$', '\1'),
  $user       = regsubst($name, '^\S+-on-(\S+)$', '\1'),
) {
  validate_hash($::accounts::public_keys)

  if $public_key =~ /^@(\S+)$/ {
    ensure_resource(
      accounts::authorized_key,
      suffix($::accounts::usergroups[$1], "-on-${user}")
    )
  } else {
    if $::accounts::public_keys[$public_key] != undef and !( $public_key in absents($::accounts::public_keys)) {
      ssh_authorized_key { "${public_key}-on-${user}":
        user   => $user,
        type   => $::accounts::public_keys[$public_key]['type'],
        key    => $::accounts::public_keys[$public_key]['key'],
      }
    }
  }
}
