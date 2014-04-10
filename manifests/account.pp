define accounts::account {
  ensure_resource(
    'user',
    $name,
    delete($::accounts::users[$name], 'authorized_keys')
  )

  $authorized_keys = suffix(
    unique(
      flatten(
        [keys($::accounts::public_keys), $name]
      )
    ),
    "-on-${name}"
  )
  accounts::authorized_key { $authorized_keys: }
}
