#!/bin/bash

set -eu

pushd $(dirname ${BASH_SOURCE})

force=${1:-""}
venv_name=".ansible-venv"
venv_path=~/$venv_name
pip_requirements="${PWD}/requirements.txt"
galaxy_requirements="${PWD}/requirements.yml"

if ! python3 -c 'import venv' > /dev/null 2>&1; then
	pip install pip --upgrade
	pip install venv
fi

if [ "${force}" = '--force' -o "${force}" = '-f' ]; then
	rm -rf $venv_path
fi

if [ ! -d $venv_path ]; then
	python3 -m venv $venv_path
	source ${venv_path}/bin/activate
	pushd $venv_path
	pip install pip --upgrade
	pip install -r ${pip_requirements}
	ansible-galaxy install -r ${galaxy_requirements}
	deactivate
	popd
fi

popd

exit 0
