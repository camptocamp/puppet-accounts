# See README.md for details.
define accounts::authorized_key(
  $ensure                   = present,
  $ssh_key                  = regsubst($name, '^(\S+)-on-\S+$', '\1'),
  $account                  = regsubst($name, '^\S+-on-(\S+)$', '\1'),
  $options                  = undef,
  $target                   = undef,
  $ssh_authorized_key_title = $::accounts::ssh_authorized_key_title,
) {
  validate_hash($::accounts::ssh_keys)

  # Retrieve $ssh_keys and $users in the current scope
  $ssh_keys = $::accounts::ssh_keys
  $users    = $::accounts::users

  if $ssh_key =~ /^@(\S+)$/ {
    if ! has_key($::accounts::usergroups, $1) {
      fail "Can't find usergroup : ${1}"
    }
    ensure_resource(
      accounts::authorized_key,
      suffix($::accounts::usergroups[$1], "-on-${account}"),
      {
        ensure                   => $ensure,
        options                  => $options,
        target                   => $target,
        ssh_authorized_key_title => $ssh_authorized_key_title,
      }
    )
  } else {
    if has_key($::accounts::ssh_keys, $ssh_key) {
      $_ssh_authorized_key_title = strformat($ssh_authorized_key_title)

      if $target == undef {
        $_user   = $account
        $_target = undef
      } else {
        $_user   = 'root'
        $_target = strformat($target)
      }
      ssh_authorized_key { $_ssh_authorized_key_title:
        ensure  => $ensure,
        key     => $::accounts::ssh_keys[$ssh_key]['public'],
        options => $::accounts::ssh_keys[$ssh_key]['options'],
        target  => $_target,
        type    => $::accounts::ssh_keys[$ssh_key]['type'],
        user    => $_user,
      }
    }
  }
}
