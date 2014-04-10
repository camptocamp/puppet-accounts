class accounts(
  $groups      = {},
  $public_keys = {},
  $users       = {},
  $accounts    = [],
) {
  create_resources(group, $groups)

  accounts::account { $accounts: }

  $absent_users = keys(absents($users))
  user { $absent_users:
    ensure => absent,
  }
}
