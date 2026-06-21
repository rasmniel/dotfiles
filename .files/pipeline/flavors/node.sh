#!/usr/bin/env bash

function pre_install__node() {
  test -f package.json || return 1
  if [ -f package-lock.json ]; then
    npm ci
  else
    npm install
  fi
  # TODO: How to declare given build command?
  # npm run build
}

function post_install__node() {
  service_dest="$SERVICE_ROOT/$1"
  sudo mkdir -p "$service_dest/bin"
  sudo cp "$(which node)" "$service_dest/bin/node"
}

function service_exec__node() {
  service="$1"
  port="$2"
  # TODO: `server.js` not necessarily correct. Read from package.json? Maybe use package.main?
  printf "%s" "/srv/$service/bin/node /srv/$service/server.js --port=$port"
}
