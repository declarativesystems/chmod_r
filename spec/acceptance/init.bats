# BATS test file to run after executing 'examples/init.pp' with puppet.
#
# For more info on BATS see https://github.com/sstephenson/bats

# Tests are really easy! just the exit status of running a command...
@test "/tmp/foo managed permissions" {
  [[ $(stat -c %a /tmp/foo) == "777" ]]
}

@test "/tmp/foo/bar managed permissions" {
  [[ $(stat -c %a /tmp/foo/bar) == "777" ]]
}

@test "/tmp/foo/bar/baz managed permissions" {
  [[ $(stat -c %a /tmp/foo/bar/baz) == "777" ]]
}

@test "/tmp/foo/inky managed perms" {
  [[ $(stat -c %a /tmp/foo/inky) == "666" ]]
}

@test "/tmp/foo/blinky managed perms" {
  [[ $(stat -c %a /tmp/foo/blinky) == "666" ]]
}

@test "/tmp/foo/bar/pinky managed perms" {
  [[ $(stat -c %a /tmp/foo/bar/pinky) == "666" ]]
}

@test "/tmp/foo/bar/baz/clyde managed perms" {
  [[ $(stat -c %a /tmp/foo/bar/baz/clyde) == "666" ]]
}

@test "/tmp/notouch was not descended" {
  [[ $(stat -c %a /tmp/notouch) == "644" ]]
}

@test "/tmp/foo/skipdir was not descended" {
  [[ $(stat -c %a /tmp/foo/skipdir) == "755" ]]
}

@test "/tmp/foo/skipdir/skipfile was not descended" {
  [[ $(stat -c %a /tmp/foo/skipdir/skipfile) == "644" ]]
}
