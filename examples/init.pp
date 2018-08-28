# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#
# @PDQTest
user { "alice":
  ensure => present,
  gid    => "bob",
}

group { "bob":
  ensure => present,
}

chmod_r { "/tmp/foo":
  want_mode => "0666",
  skip      => "/tmp/foo/skipdir",
}

chmod_r { "/foo":
  want_mode => "0666",
  skip      => "/tmp/foo/skipdir",
  watch     => User["alice"],
}

chmod_r { "/bar":
  want_mode => "0666",
  skip      => "/tmp/foo/skipdir",
  watch     => [User["alice"], Group["bob"]],
}