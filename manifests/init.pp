class accounts(
  $groups      = {},
  $public_keys = {},
  $users       = {},
) {
  create_resources(group, $groups)
  create_resources(accounts::user, $users)
}
