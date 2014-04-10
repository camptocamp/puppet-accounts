define accounts::user(
  $ensure      = undef,
  $comment     = undef,
  $groups      = undef,
  $managehome  = undef,
  $shell       = undef,
  $system      = undef,
  $uid         = undef,

  $public_keys = [],
) {
  validate_array($public_keys)
  validate_hash($::accounts::public_keys)

  ensure_resource(
    'user',
    $name,
    {
      ensure     => $ensure,
      comment    => $comment,
      groups     => $groups,
      managehome => $managehome,
      shell      => $shell,
      uid        => $uid,
    }
  )

  $authorized_keys = suffix(keys($::accounts::public_keys), "-on-${name}")
  accounts::authorized_key { $authorized_keys: }
}
