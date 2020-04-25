#!/bin/bash

odrive=/root/.odrive-agent/bin/odrive

function error_exit() {
  echo $1 1>&2
  exit 1
}

function on_exit() {
  local exit_code=$1
  exit $exit_code
}

function sync() {
  $odrive refresh "$1"
  find "$1" -name '*.cloud' -o -name '*.cloudf' | while read f
  do
    $odrive sync "$f"
    if [ ${f##*.} = 'cloudf' ]; then
      sync "${f%.*}"
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

  sync /odrive
}

main