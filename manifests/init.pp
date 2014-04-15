class accounts(
  $groups     = {},
  $ssh_keys   = {},
  $users      = {},
  $usergroups = {},
  $accounts   = {},
) {
  create_resources(group, $groups)

  create_resources(accounts::account, $accounts)

  # Remove users marked as absent
  $absent_users = keys(absents($users))
  user { $absent_users:
    ensure => absent,
  }
}
