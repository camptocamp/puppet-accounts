# See README.md for details.
# @param groups [Hash] Hash of groups to create (passed to create_resources). Defaults to {}.
# @param groups_membership [Hash] Default value for the users' membership parameter. Refer to the Puppet documentation for more information.
# @param ssh_keys [Hash] Hash of SSH public keys that can be assigned to users (see Usage above).
# @param users [Hash] Hash of users (see Usage above)
# @param usergroups [Hash] Hash of user groups (see Usage above).
# @param accounts [Hash]  Hash of accounts to create (see Usage above).
# @param start_uid [Integer] Sets the lowest uid for non system users. This is a system setting and also affects users created outside of this module.
# @param start_gid [Integer] Sets the lowest gid for non system groups. This is a system setting and also affects groups or users created outside of this module.
# @param purge_ssh_keys [Boolean] Default value for users' purge_ssh_keys parameter. When true all SSH keys in a users authorized_keys file not managed by Puppet will be deleted. Defaults to false.
# @param ssh_authorized_key_title [String] Default value for users' ssh_authorized_key_title parameter.
# @param shell [String] Default value for users' shell parameter. Default is the system default (usually /bin/sh).
# @param managehome [Boolean] Default value for users' managehome parameter.
# @param forcelocal [Boolean] Set the resource "user" parameter so that the users are not created/supressed in external user directories (i.e. LDAP).
class accounts (
  Hash $groups                      = {},
  Optional[Hash] $groups_membership = undef,
  Hash $ssh_keys                    = {},
  Hash $users                       = {},
  Hash $usergroups                  = {},
  Hash $accounts                    = {},
  Optional[Integer] $start_uid      = undef,
  Optional[Integer] $start_gid      = undef,
  Boolean $purge_ssh_keys           = false,
  String $ssh_authorized_key_title  = '%{ssh_key}-on-%{account}',
  Optional[String] $shell           = undef,
  Boolean $managehome               = true,
  Boolean $forcelocal               = true,
) {
  include accounts::config

  create_resources(group, $groups)

  create_resources(accounts::account, $accounts)

  # Remove users marked as absent
  $absent_users = keys(absents($users))
  user { $absent_users:
    ensure     => absent,
    managehome => $managehome,
    forcelocal => $forcelocal,
  }
}
