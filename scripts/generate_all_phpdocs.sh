#!/usr/bin/env bash
set -ex

SCRIPTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$( dirname "${SCRIPTSDIR}" )" && pwd )"
PHPDOCROOT="${ROOT}/phpdocs"

for version in `ls build/html/`
do
  # Find out the Moodle branch name from the .moodlebranch file in the docs repo.
  cd "${ROOT}"
  moodlebranch=`git show "remotes/origin/${version}":.moodlebranch`

  # Change into the Moodle directory to get some information.
  export INPUT="${ROOT}/.moodle"
  cd "${INPUT}"

  # Checkout the correct branch.
  git fetch origin "${moodlebranch}"
  git checkout "remotes/origin/${moodlebranch}"
  HASH=`git log -1 --format="%h"`

  echo "Building phpdocs for ${HASH}"

  # Generate the php documentation
  docker run \
      -v "${ROOT}":"${ROOT}" \
      -w "${ROOT}" \
      -e HASH="${HASH}" \
      -e INPUT="${INPUT}" \
      -e VERSION="${version}" \
      doxygen
done
