# @summary Recursive chmod
#
# Perform the equivalent of a recursive chmod (chmod -R) when required.  This
# avoids having to use recursive `file` resources with large directories as this
# can bring about poor performance in the Puppet Master as well as placing
# high demand on storage requirements
#
# @param dir The directory to check and chmod.  Defaults to $name
# @param want_mode The octal permissions to chmod to and check for
# @param watch Resource reference to watch (eg Package['foo']), if set, we will
#   only run the chown if this resource sends a refresh event AND we identify
#   files with incorrect ownership.  Note that if this parameter is not set,
#   the chmod command will run every time find tells us we need to (eg
#   every puppet run)
# @param skip Do not include this directory when running chmod
define chmod_r(
    String              $want_mode,
    String              $dir        = $name,
    Optional[Resource]  $watch      = undef,
    Optional[String]    $skip       = undef,
) {
  if $watch {
    $refreshonly  = true
    $_watch       = $watch
  } else {
    $refreshonly  = false
    $_watch       = undef
  }

  # must use '!' instead of -not on solaris or we get a bad command error
  if $facts['os']['family'] == 'Solaris' {
    $predicate = '!'
  } else {
    $predicate = '-not'
  }

  if $skip {
    $_skip = "-wholename ${skip} -prune -o"
  } else {
    $_skip = ""
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
    command => "find ${dir} ${_skip} -type f -exec chmod ${want_mode} {} \\;",
    onlyif  => "find ${dir} ${_skip} \\( -type f ${predicate} -perm ${want_mode} \\) -print | grep .",
  }

  # how the hell do you do this as a bitmask without writing several lines?
  # First off, there is no bitmask operator in puppet dsl... Tried bash, too
  # hard.  The conversions wanted are simple and we can coearse a string:
  # X  1 -> 1
  # W  2 -> 2
  # R  4 -> 5
  # RW 6 -> 7
  # So swallow pride and use a nested regexp...
  $_want_mode = regsubst(regsubst($want_mode, '4', '5', 'G'), '6', '7', 'G')
  exec { "chmod -R for ${dir} (dirs)":
    command => "find ${dir} ${_skip} -type d -exec chmod ${_want_mode} {} \\;",
    onlyif  => "find ${dir} ${_skip} \\( -type d ${predicate} -perm ${_want_mode} \\) -print | grep .",
  }
}
