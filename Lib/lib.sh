#!/usr/bin/env bash

function checkroot() {
    if [[ $EUID -ne 0 ]]; then
      printf "\e[1;31mThis script must be run as root
      Try: sudo %s\e[0m" "$PROGNAME"
      echo
    fi
}