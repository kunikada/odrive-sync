#!/bin/bash

odrive=/root/.odrive-agent/bin/odrive
rootdir=/odrive

function error_exit() {
  echo $1 1>&2
  exit 1
}

function on_exit() {
  local exit_code=$1
  exit $exit_code
}

function wait() {
  while [ "$($odrive syncstate "$1" | head -n 1)" != 'Synced' ]
  do
    sleep 5
  done
}

function recursive_sync() {
  find "$1" -name '*.cloud' -o -name '*.cloudf' | while read f
  do
    $odrive sync "$f"
    wait "$f"
    if [ ${f##*.} = 'cloudf' ]; then
      recursive_sync "${f%.*}"
    fi
  done
}

function main() {
  trap 'on_exit $?' EXIT

  if [ ! -f odrive.sync.enabled ]; then
    $odrive authenticate $AUTH_KEY
    $odrive mount /odrive /
    touch odrive.sync.enabled
  fi

  find $rootdir -type d | while read d
  do
    $odrive refresh "$d"
    wait "$d"
  done

  recursive_sync $rootdir
}

main
