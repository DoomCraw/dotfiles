#!/bin/bash

set -eu

test -n "${WSL_DISTRO_NAME}" && install_component "npiperelay"

. ./bootstrap.sh
. ./components/ansible-venv/bootstrap.sh

exit 0