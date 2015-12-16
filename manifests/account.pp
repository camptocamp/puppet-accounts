# See README.md for details.
define accounts::account(
  $ensure                   = 'present',
  $allowdupe                = undef,
  $attribute_membership     = undef,
  $attributes               = undef,
  $auth_membership          = undef,
  $auths                    = undef,
  $comment                  = undef,
  $expiry                   = undef,
  $forcelocal               = undef,
  $gid                      = $::accounts::groups_membership,
  $groups                   = undef,
  $home                     = undef,
  $ia_load_module           = undef,
  $iterations               = undef,
  $key_membership           = undef,
  $keys                     = undef,
  $loginclass               = undef,
  $managehome               = $::accounts::managehome,
  $membership               = undef,
  $password                 = undef,
  $password_max_age         = undef,
  $password_min_age         = undef,
  $profile_membership       = undef,
  $profiles                 = undef,
  $project                  = undef,
  $provider                 = undef,
  $purge_ssh_keys           = $::accounts::purge_ssh_keys,
  $role_membership          = undef,
  $roles                    = undef,
  $salt                     = undef,
  $shell                    = $::accounts::shell,
  $system                   = undef,
  $uid                      = undef,

  $user                     = $name,
  $authorized_keys          = [],
  $authorized_keys_target   = undef,
  $ssh_authorized_key_title = $::accounts::ssh_authorized_key_title,
  $ssh_options              = undef,
) {
  if $user =~ /^@(\S+)$/ {
    if ! has_key($::accounts::usergroups, $1) {
      fail "Can't find usergroup : ${1}"
    }
    ensure_resource(
      accounts::account,
      $::accounts::usergroups[$1],
      {
        ensure                   => $ensure,
        allowdupe                => $allowdupe,
        attribute_membership     => $attribute_membership,
        attributes               => $attributes,
        auth_membership          => $auth_membership,
        auths                    => $auths,
        comment                  => $comment,
        expiry                   => $expiry,
        forcelocal               => $forcelocal,
        gid                      => $gid,
        groups                   => $groups,
        home                     => $home,
        ia_load_module           => $ia_load_module,
        iterations               => $iterations,
        key_membership           => $key_membership,
        keys                     => $keys,
        loginclass               => $loginclass,
        managehome               => $managehome,
        membership               => $membership,
        password                 => $password,
        password_max_age         => $password_max_age,
        password_min_age         => $password_min_age,
        profile_membership       => $profile_membership,
        profiles                 => $profiles,
        project                  => $project,
        provider                 => $provider,
        purge_ssh_keys           => $purge_ssh_keys,
        role_membership          => $role_membership,
        roles                    => $roles,
        salt                     => $salt,
        shell                    => $shell,
        system                   => $system,
        uid                      => $uid,
        authorized_keys          => $authorized_keys,
        authorized_keys_target   => $authorized_keys_target,
        ssh_authorized_key_title => $ssh_authorized_key_title,
        ssh_options              => $ssh_options,
      }
    )
  } else {
    user { $name:
      ensure               => pick($::accounts::users[$name]['ensure'], $ensure),
      allowdupe            => pick($::accounts::users[$name]['allowdupe'], $allowdupe),
      attribute_membership => pick($::accounts::users[$name]['attribute_membership'], $attribute_membership),
      attributes           => pick($::accounts::users[$name]['attributes'], $attributes),
      auth_membership      => pick($::accounts::users[$name]['auth_membership'], $auth_membership),
      auths                => pick($::accounts::users[$name]['auths'], $auths),
      comment              => pick($::accounts::users[$name]['comment'], $comment),
      expiry               => pick($::accounts::users[$name]['expiry'], $expiry),
      forcelocal           => pick($::accounts::users[$name]['forcelocal'], $forcelocal),
      gid                  => pick($::accounts::users[$name]['gid'], $gid),
      groups               => pick($::accounts::users[$name]['groups'], $groups),
      home                 => pick($::accounts::users[$name]['home'], $home, "/home/${name}"),
      ia_load_module       => pick($::accounts::users[$name]['ia_load_module'], $ia_load_module),
      iterations           => pick($::accounts::users[$name]['iterations'], $iterations),
      key_membership       => pick($::accounts::users[$name]['key_membership'], $key_membership),
      keys                 => pick($::accounts::users[$name]['keys'], $keys),
      loginclass           => pick($::accounts::users[$name]['loginclass'], $loginclass),
      managehome           => pick($::accounts::users[$name]['managehome'], $managehome),
      membership           => pick($::accounts::users[$name]['membership'], $membership),
      password             => pick($::accounts::users[$name]['password'], $password),
      password_max_age     => pick($::accounts::users[$name]['password_max_age'], $password_max_age),
      password_min_age     => pick($::accounts::users[$name]['password_min_age'], $password_min_age),
      profile_membership   => pick($::accounts::users[$name]['profile_membership'], $profile_membership),
      profiles             => pick($::accounts::users[$name]['profiles'], $profiles),
      project              => pick($::accounts::users[$name]['project'], $project),
      provider             => pick($::accounts::users[$name]['provider'], $provider),
      purge_ssh_keys       => pick($::accounts::users[$name]['purge_ssh_keys'], $purge_ssh_keys),
      role_membership      => pick($::accounts::users[$name]['role_membership'], $role_membership),
      roles                => pick($::accounts::users[$name]['roles'], $roles),
      salt                 => pick($::accounts::users[$name]['salt'], $salt),
      shell                => pick($::accounts::users[$name]['shell'], $shell),
      system               => pick($::accounts::users[$name]['system'], $system),
      uid                  => pick($::accounts::users[$name]['uid'], $uid),
    }

    if $ensure != absent {
      if is_string($authorized_keys) or is_array($authorized_keys) {
        $user_has_key = has_key($::accounts::ssh_keys, $name) and $::accounts::ssh_keys[$name]['ensure'] != 'absent'
        $_authorized_keys = $user_has_key ? {
          true  => suffix(unique( delete_undef_values( flatten( [$authorized_keys, $name] ) ) ),"-on-${name}"),
          false => suffix(unique( delete_undef_values( flatten( [$authorized_keys] ) ) ),"-on-${name}"),
        }
        accounts::authorized_key { $_authorized_keys:
          account                  => $name,
          options                  => $ssh_options,
          target                   => $authorized_keys_target,
          ssh_authorized_key_title => $ssh_authorized_key_title,
        }
      } elsif is_hash($authorized_keys) {
        $tmp_hash = merge({"${name}" => {},}, $authorized_keys)
        $_authorized_keys = hash(
          zip(suffix(keys($tmp_hash), "-on-${name}"), values($tmp_hash))
        )
        create_resources(
          accounts::authorized_key,
          $_authorized_keys,
          {
            options                  => $ssh_options,
            target                   => $authorized_keys_target,
            ssh_authorized_key_title => $ssh_authorized_key_title,
          }
        )
      } else {
        fail 'authorized_keys must be a String, an Array or a Hash'
      }
      if $::accounts::ssh_keys[$name] != undef and $::accounts::ssh_keys[$name]['private'] != undef {
        # NOTE: getparam(User[$user], 'home') would do the trick to fetch
        # user's home dir, but it depends on parsing order
        #
        # $home = getparam(User[$user], 'home')
        # file { "${home}/.ssh/id_rsa":
        #   content => $::accounts::ssh_keys[$name]['private'],
        # }
        #
        # Another solution would be to use puppetdbquery:
        #
        # $ret = query_resources("fqdn='${::fqdn}'", "User['${user}']")
        # $home = $ret[$::fqdn][0]['parameters']['home']
        #
        # TODO: Fix unless so that it replaces the key
        exec { "put ssh private key ${name} for user ${user}":
          command => "/bin/echo '${::accounts::ssh_keys[$name]['private']}' > ~${user}/.ssh/id_rsa; /bin/chown ${user} ~${user}/.ssh/id_rsa; /bin/chmod 600 ~${user}/.ssh/id_rsa",
          unless  => "/usr/bin/test -f ~${user}/.ssh/id_rsa",
        }
      }
    }

    if ! $purge_ssh_keys {
      $keys_to_remove = suffix(keys(absents($::accounts::ssh_keys)), "-on-${name}")
      accounts::authorized_key { $keys_to_remove:
        ensure                   => absent,
        account                  => $name,
        target                   => $authorized_keys_target,
        ssh_authorized_key_title => $ssh_authorized_key_title,
      }
    }
  }
}
