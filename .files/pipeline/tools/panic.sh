#!/usr/bin/env bash

panic() {
  echo "$1" >&2
  exit 1
}

panic_usage() {
  panic "Usage: ppl <clone|service|install|publish|uninstall> [--public|--hard] <project>"
}
