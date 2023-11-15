# See README.md for details.
# @param ensure [String] The state of the resource.
# @param ssh_key [String] The name of the ssh key.
# @param account [String] The name of the account.
# @param options [String] The options of the ssh key.
# @param target [String] The target of the ssh key.
# @param ssh_authorized_key_title [String] The title of the ssh_authorized_key resource.
define accounts::authorized_key (
  String $ensure                   = present,
  String $ssh_key                  = regsubst($name, '^(\S+)-on-\S+$', '\1'),
  String $account                  = regsubst($name, '^\S+-on-(\S+)$', '\1'),
  Optional[String] $options        = undef,
  Optional[String] $target         = undef,
  String $ssh_authorized_key_title = $accounts::ssh_authorized_key_title,
) {
  # Retrieve $ssh_keys and $users in the current scope
  $ssh_keys = $accounts::ssh_keys
  $users    = $accounts::users

  if $ssh_key =~ /^@(\S+)$/ {
    if ! ($1 in $accounts::usergroups) {
      fail "Can't find usergroup : ${1}"
    }
    ensure_resource(
      accounts::authorized_key,
      suffix($accounts::usergroups[$1], "-on-${account}"),
      {
        ensure                   => $ensure,
        options                  => $options,
        target                   => $target,
        ssh_authorized_key_title => $ssh_authorized_key_title,
      }
    )
  } else {
    if ($ssh_key in $accounts::ssh_keys) {
      $_ssh_authorized_key_title = strformat($ssh_authorized_key_title)

      if $target == undef {
        $_user   = $account
        $_target = undef
      } else {
        $_user   = 'root'
        $_target = strformat($target)
      }
      if $accounts::ssh_keys[$ssh_key]['options'] {
        $_options = $accounts::ssh_keys[$ssh_key]['options']
      } else {
        $_options = $options
      }

      ssh_authorized_key { $_ssh_authorized_key_title:
        ensure  => $ensure,
        key     => $accounts::ssh_keys[$ssh_key]['public'],
        options => $_options,
        target  => $_target,
        type    => $accounts::ssh_keys[$ssh_key]['type'],
        user    => $_user,
      }
    }
  }
}
