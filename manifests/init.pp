# See README.md for details.
class accounts(
  $groups                   = {},
  $groups_membership        = undef,
  $ssh_keys                 = {},
  $users                    = {},
  $usergroups               = {},
  $accounts                 = {},
  $start_uid                = undef,
  $start_gid                = undef,
  $purge_ssh_keys           = false,
  $ssh_authorized_key_title = '%{ssh_key}-on-%{account}',
  $shell                    = undef,
) {
  include ::accounts::config

  create_resources(group, $groups)

  create_resources(accounts::account, $accounts)

  # Remove users marked as absent
  $absent_users = keys(absents($users))
  user { $absent_users:
    ensure => absent,
  }
}
