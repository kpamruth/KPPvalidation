#!/bin/bash
# This will be autogenerated by "havoc hi5 bootstrap" cmd

FAVA_CONTROLLER=$1

function install_havoc_dependencies() {
  HI5_INSTALL_HAVOC_DEPENDENCIES
}

function install_test_tools() {
  HI5_INSTALL_TEST_TOOLS
}

function install_autoval_rpms() {
    yuminstall fb-havoc-autoval
}
function install_pip_dependencies() {
    pip install --no-index --find-links=file:///shared/fava/pip/  requests
}

function yummakecache() {
    echo "[fava]
name=CentOS7 - fava
baseurl=file:///shared/fava/pkgs
enabled=1
gpgcheck=0" > /etc/yum.repos.d/fava.repo

    yum --disablerepo=\* --enablerepo=fava makecache
    YUM_CACHED=1
}

function yuminstall() {
    [[ -z $YUM_CACHED ]] && yummakecache
    echo  "$*"
    yum --disablerepo=\* --enablerepo=fava install -y "$*"
}

function install_pip_dependencies() {
    pip install --no-index --find-links \
      http://"$FAVA_CONTROLLER"/shared/fava_bundle/pip_cache/ \
      requests --trusted-host "$FAVA_CONTROLLER"
}

function update_fava_env() {
    cat >> /etc/fava.env << EOF
HAVOC_SITE_SETTINGS=site_settings_fava_lab.json
PYTHONPATH=/usr/facebook
EOF
}
install_pip_dependencies
update_fava_env
install_autoval_rpms
install_havoc_dependencies
install_test_tools

ntpdate "$FAVA_CONTROLLER"
