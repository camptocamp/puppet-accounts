class accounts(
  $groups      = {},
  $public_keys = {},
  $users       = {},
  $accounts    = [],
) {
  create_resources(group, $groups)
  accounts::account { $accounts: }
}
