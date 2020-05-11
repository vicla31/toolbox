#!/usr/bin/env bash

echo "SHELLCHECK"
shellcheck '../Lib/lib.sh'

echo "UNIT TESTS"

testcheckroot() {
  return=$(checkroot -h)
  assertContains 'This script must be run as root' "${return}" "This script must be run as root"
}

oneTimeSetUp() {
  # Load script under test.
  source '../Lib/lib.sh' > /dev/null
}

# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
source shunit2/shunit2