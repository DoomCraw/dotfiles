#!/bin/bash


pushd $(dirname ${BASH_SOURCE})
git pull origin main

venv_name=".ansible-venv"
venv_path=~/$venv_name
python_requirements="${PWD}/requirements.txt"
ansible_requirements="${PWD}/requirements.yml"

if [ -d $venv_path ]; then
	exit 0
fi

pushd ~
pip install pip --upgrade
pip install venv

python3 -m venv $venv_path
source ${venv_path}/bin/activate
pushd $venv_path
pip install pip --upgrade
pip install -r ${python_requirements}
ansible-galaxy install -r ${ansible_requirements}
deactivate
popd

popd

popd


unset venv_name venv_path python_requirements ansible_requirements

exit 0