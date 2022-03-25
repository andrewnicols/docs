#!/usr/bin/env bash
set -e

SCRIPTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$( dirname "${SCRIPTSDIR}" )" && pwd )"
PHPDOCROOT="${ROOT}/phpdocs"

VERSIONLIST=(${VERSIONLIST[@]:-master})
BRANCHLIST=(${BRANCHLIST[@]:-master})

echo "Building for the following versions (branches): ${VERSIONLIST[*]} (${BRANCHLIST[*]})"

for index in ${!VERSIONLIST[@]}; do
  version=${VERSIONLIST[$index]}
  moodlebranch=${BRANCHLIST[$index]}
  echo "Generating phpdocs for ${version} using branch ${moodlebranch}"

  # Change into the Moodle directory to get some information.
  export INPUT="${ROOT}/.moodle"
  cd "${INPUT}"

  # Checkout the correct branch.
  echo "Checking out remote branch"
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

  # Move the built files into the build directory
  echo "Moving into place"
  cd "${ROOT}"
  mkdir -p "build/apidocs/${version}"
  mv "build/phpdocs/${version}/html" "build/apidocs/${version}/phpdocs"
done
