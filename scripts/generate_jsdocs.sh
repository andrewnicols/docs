#!/usr/bin/env bash
set -e

SCRIPTSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$( dirname "${SCRIPTSDIR}" )" && pwd )"
MOODLEROOT="${ROOT}/.moodle"
JSDOCROOT="${MOODLEROOT}/jsdoc"

VERSIONLIST=(${VERSIONLIST[@]:-master})
BRANCHLIST=(${BRANCHLIST[@]:-master})

echo "Building for the following versions (branches): ${VERSIONLIST[*]} (${BRANCHLIST[*]})"

for index in ${!VERSIONLIST[@]}; do
  version=${VERSIONLIST[$index]}
  moodlebranch=${BRANCHLIST[$index]}
  echo "Generating jsdocs for {$version} using branch ${moodlebranch}"

  echo "Checking out remote branch"
  cd "${MOODLEROOT}"
  git fetch origin "${moodlebranch}"
  git checkout "remotes/origin/${moodlebranch}"

  echo "Building jsdoc"
  npm ci
  npx grunt jsdoc

  echo "Moving into place"
  cd "${ROOT}"
  mkdir -p "build/apidocs/${version}"
  mv "${JSDOCROOT}" "build/apidocs/${version}/jsdoc"
done
