#!/usr/bin/env bash

echo "SHELLCHECK"
shellcheck '../Files&Folders/listfiles.sh'

echo "UNIT TESTS"

testcommandArgsPretty() {
  commandargs
  assertEquals 'Non Pretty format' '0' "${PRETTY}"
  commandargs -p
  assertEquals 'Pretty format' '1' "${PRETTY}"
  commandargs --pretty
  assertEquals 'Pretty format' '1' "${PRETTY}"
}
testcommandArgsRecursive() {
  commandargs
  assertEquals 'Non recursive' '0' "${RECURSIVE}"
  commandargs -r
  assertEquals 'recursive' '1' "${RECURSIVE}"
  commandargs -R
  assertEquals 'recursive' '1' "${RECURSIVE}"
  commandargs --recursive
  assertEquals 'recursive' '1' "${RECURSIVE}"
}

testcommandArgsDirectory() {
  commandargs
  assertNull 'Non Directory' "${DIRTOSCAN}"
  commandargs dir
  assertEquals 'Directory passed' 'dir' "${DIRTOSCAN}"
  commandargs dir\ with\ space
  assertEquals 'Directory passed' 'dir with space' "${DIRTOSCAN}"
  commandargs -p -r dir
  assertEquals 'Directory passed' 'dir' "${DIRTOSCAN}"
}

testcommandArgsHelp() {
  return=$(commandargs -h)
  assertContains 'Help displayed' "${return}" "Programm list existing filenames"
  return=$(commandargs --help)
  assertContains 'Help displayed' "${return}" "Programm list existing filenames"
}

oneTimeSetUp() {
  # Create test directory
  testDir="${SHUNIT_TMPDIR}/testDirectory"
  mkdir -p "${testDir}/testSubdirectory"
  for i in {1..5}; do
      touch ${testDir}/file$i.txt
      touch ${testDir}/testSubdirectory/anotherfile$i.txt
  done
  ln -s ${testDir}/testSubdirectory/anotherfile5.txt ${testDir}/anotherfile5.txt

  # Load script under test.
  source '../Files&Folders/listfiles.sh' ${testDir} > /dev/null
}

tearDown() {
  rm -fr "${testDir}"
}

# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
source shunit2/shunit2