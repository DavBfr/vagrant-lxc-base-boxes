#!/bin/bash
set -e

source common/ui.sh

export VAGRANT_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

info "Preparing root user..."

# Create vagrant user
if $(grep -q 'ubuntu' ${ROOTFS}/etc/shadow); then
  debug 'ubuntu user exist, removing ubuntu user...'
  chroot ${ROOTFS} userdel -r ubuntu &>> ${LOG}
  log 'Deleted ubuntu user.'
fi

# Configure SSH access
if [ -d ${ROOTFS}/root/.ssh ]; then
  log 'Skipping root SSH credentials configuration'
else
  debug 'SSH key has not been set'
  mkdir -p ${ROOTFS}/root/.ssh
  echo $VAGRANT_KEY > ${ROOTFS}/root/.ssh/authorized_keys
  chown -R 0:0 ${ROOTFS}/root/.ssh
  chmod 600 ${ROOTFS}/root/.ssh/authorized_keys
  log 'SSH credentials configured for the root user.'
fi
