# Chmod_r
#
# Perform a recursive chmod (chmod -R) when required
define chmod_r(
    $want_mode,
    $dir    = $title,
    $watch  = false,
) {
  if $watch {
    $refreshonly  = true
    $_watch       = $watch
  } else {
    $refreshonly  = false
    $_watch       = undef
  }

  Exec {
    refreshonly => $refreshonly,
    subscribe   => $_watch,
    path        => [
      "/bin",
      "/usr/bin",
    ],
  }

  exec { "chmod -R for ${dir} (files)":
    command => "find ${dir} -type f -exec chmod ${want_mode} {} \\;",
    onlyif  => "find ${dir} \\( -type f -not -perm ${want_mode} \\) | grep .",
  }

  # how the hell do you do this as a bitmask without writing several lines?
  # First off, there is no bitmask operator in puppet dsl... Tried bash, too
  # hard.  The converions wanted are simple and we can coearse a string:
  # X  1 -> 1
  # W  2 -> 2
  # R  4 -> 5
  # RW 6 -> 7
  # So swallow pride and use a nested regexp...
  $_want_mode = regsubst(regsubst($want_mode, '4', '5', 'G'), '6', '7', 'G')
  notify {"mode ${want_mode} changed to ${_want_mode}":}
  exec { "chmod -R for ${dir} (dirs)":
    command => "find ${dir} -type d -exec chmod ${_want_mode} {} \\;",
    onlyif  => "find ${dir} \\( -type d -not -perm ${_want_mode} \\) | grep .",
  }
}
