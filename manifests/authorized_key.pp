define accounts::authorized_key(
  $public_key = regsubst($name, '^(\S+)-on-\S+$', '\1'),
  $user       = regsubst($name, '^\S+-on-(\S+)$', '\1'),
  $options    = undef,
  $target     = undef,
) {
  validate_hash($::accounts::ssh_keys)

  if $public_key =~ /^@(\S+)$/ {
    ensure_resource(
      accounts::authorized_key,
      suffix($::accounts::usergroups[$1], "-on-${user}"),
      {
        options => $options,
        target  => $target,
      }
    )
  } else {
    if $::accounts::ssh_keys[$public_key] != undef and !( $public_key in absents($::accounts::ssh_keys)) {
      ssh_authorized_key { "${public_key}-on-${user}":
        key     => $::accounts::ssh_keys[$public_key]['public'],
        options => $options,
        target  => $target,
        type    => $::accounts::ssh_keys[$public_key]['type'],
        user    => $user,
      }
    }
  }
}
