# BATS test file to run before executing 'examples/init.pp' with puppet.
#
# For more info on BATS see https://github.com/sstephenson/bats

# Tests are really easy! just the exit status of running a command...
@test "/tmp/foo managed permissions" {
  [[ $(stat -c %a /tmp/foo) == "755" ]]
}

@test "/tmp/foo/bar managed permissions" {
  [[ $(stat -c %a /tmp/foo/bar) == "755" ]]
}

@test "/tmp/foo/bar/baz managed permissions" {
  [[ $(stat -c %a /tmp/foo/bar/baz) == "755" ]]
}

@test "/tmp/foo/inky default perms" {
  [[ $(stat -c %a /tmp/foo/inky) == "644" ]]
}

@test "/tmp/foo/blinky default perms" {
  [[ $(stat -c %a /tmp/foo/blinky) == "644" ]]
}

@test "/tmp/foo/bar/pinky default perms" {
  [[ $(stat -c %a /tmp/foo/bar/pinky) == "644" ]]
}

@test "/tmp/foo/bar/baz/clyde default perms" {
  [[ $(stat -c %a /tmp/foo/bar/baz/clyde) == "644" ]]
}

@test "/tmp/notouch default perms" {
  [[ $(stat -c %a /tmp/foo/bar/baz/clyde) == "644" ]]
}

@test "/tmp/foo/skipdir default perms" {
  [[ $(stat -c %a /tmp/foo/skipdir) == "755" ]]
}

@test "/tmp/foo/skipdir/skipfile default perms" {
  [[ $(stat -c %a /tmp/foo/skipdir/skipfile) == "644" ]]
}
