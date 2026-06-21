#!/usr/bin/env bash

function flavor_step() {
  local step="$1"
  local flavor="$2"
  local service="$3"

  fn="${step}__$flavor"
  if declare -f "$fn" > /dev/null; then
    "$fn" "$service"
  fi
}

