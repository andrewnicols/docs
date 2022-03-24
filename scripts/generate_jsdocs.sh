#!/bin/sh

for version in `ls build/html/`
do
  moodlebranch=`git show "remotes/origin/${version}":.moodlebranch`
  cd .moodle
  git fetch origin "${moodlebranch}"
  git checkout "remotes/origin/${moodlebranch}"
  cat version.php
  npm ci
  npx grunt jsdoc
  cd -
  cp -r .moodle/jsdoc "build/html/$version/jsdoc"
done
