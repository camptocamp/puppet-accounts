define accounts::account {
  ensure_resource(
    'user',
    $name,
    delete($::accounts::users[$name], 'authorized_keys')
  )

  $authorized_keys = suffix(keys($::accounts::public_keys), "-on-${name}")
  accounts::authorized_key { $authorized_keys: }
}
