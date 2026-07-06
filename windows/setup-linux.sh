#!/bin/bash
# Install PowerShell Core to Linux

RED=""
GREEN=""
BLUE=""
YELLOW=""
NC=""

info () {}
error () {}
warn () {}
success () {}


source /etc/os-release
case "${ID}" in
    "ubuntu") 
    ;;
    "fedora")
    ;;
    *)
        error "Distro not supported."
    ;;
esac

exit 0