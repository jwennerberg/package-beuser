#!/bin/bash

#
# Create packages for beuser
#
# (c)2013 Ericsson 
# Developed by Kalle Kiviaho <kalle.kiviaho@ericsson.com>
#

#
# Install fpm, needed to run the script
#   gem install fpm
#
# Install heirloom-tools to support building Solaris packages
#   Download latest heirloom-tools from http://spacewalk.redhat.com/yum/latest/RHEL/6/x86_64/
#   and install on machine to build packages.
#

umask 0022

TYPE=$1

NAME=beuser
VERSION=0.3
ITERATION=1
MAINTAINER=kalle.kiviaho@ericsson.com

# Collect the beuser binaries for packaging
BEUSERPATH=/proj/eis_dipub/eis_cm_repo/beuser
mkdir -p beuser/rhel/5/i386/bin
cp -a ${BEUSERPATH}/beuser.rhl5i386 beuser/rhel/5/i386/bin/beuser
mkdir -p beuser/rhel/5/x86_64/bin
cp -a ${BEUSERPATH}/beuser.rhl5x64 beuser/rhel/5/x86_64/bin/beuser
mkdir -p beuser/rhel/6/x86_64/bin
cp -a ${BEUSERPATH}/beuser.rhl6x64 beuser/rhel/6/x86_64/bin/beuser
mkdir -p beuser/rhel/6/i386/bin
cp -a ${BEUSERPATH}/beuser.rhl6i386 beuser/rhel/6/i386/bin/beuser
mkdir -p beuser/suse/9/i386/bin
cp -a ${BEUSERPATH}/beuser.sles9i386 beuser/suse/9/i386/bin/beuser
mkdir -p beuser/suse/10/x86_64/bin
cp -a ${BEUSERPATH}/beuser.sles10x64 beuser/suse/10/x86_64/bin/beuser
mkdir -p beuser/suse/10/i386/bin
cp -a ${BEUSERPATH}/beuser.sles10i386 beuser/suse/10/i386/bin/beuser
mkdir -p beuser/suse/11/x86_64/bin
cp -a ${BEUSERPATH}/beuser.sles11x64 beuser/suse/11/x86_64/bin/beuser
mkdir -p beuser/suse/11/i386/bin
cp -a ${BEUSERPATH}/beuser.sles11i386 beuser/suse/11/i386/bin/beuser
mkdir -p beuser/ubuntu/12.04/x86_64/bin
cp -a ${BEUSERPATH}/beuser.ubuntu1204x64 beuser/ubuntu/12.04/x86_64/bin/beuser
mkdir -p beuser/ubuntu/13.04/x86_64/bin
cp -a ${BEUSERPATH}/beuser.ubuntu1304x64 beuser/ubuntu/13.04/x86_64/bin/beuser
mkdir -p beuser/solaris/10/sparc/usr/bin
cp -a ${BEUSERPATH}/beuser.sol10sparc beuser/solaris/10/sparc/usr/bin/beuser
mkdir -p beuser/solaris/10/x86_64/usr/bin
cp -a ${BEUSERPATH}/beuser.sol10x64 beuser/solaris/10/x86_64/usr/bin/beuser

mkdir packages

FPMCOMMONARGS="--name $NAME -s dir --version ${VERSION} --maintainer $MAINTAINER"
FPMRPMARGS="$FPMCOMMONARGS -t rpm --rpm-user root --rpm-group root --package ../../../../packages"
FPMDEBARGS="$FPMCOMMONARGS -t deb --deb-user root --deb-group root"
FPMSOLARGS="$FPMCOMMONARGS -t solaris --prefix /usr/bin -a all --solaris-user root --solaris-group root"


# Redhat
  (cd beuser/rhel/5/i386 ; fpm -a noarch --iteration ${ITERATION}.el5 $FPMRPMARGS .)
  mv packages/${NAME}-${VERSION}-${ITERATION}.el5.noarch.rpm packages/${NAME}-${VERSION}-${ITERATION}.el5.i386.rpm 
  (cd beuser/rhel/6/i386 ; fpm -a noarch --iteration ${ITERATION}.el6 $FPMRPMARGS .)
  mv packages/${NAME}-${VERSION}-${ITERATION}.el6.noarch.rpm packages/${NAME}-${VERSION}-${ITERATION}.el6.i686.rpm 
  (cd beuser/rhel/5/x86_64 ; fpm --iteration ${ITERATION}.el5 $FPMRPMARGS .)
  (cd beuser/rhel/6/x86_64 ; fpm --iteration ${ITERATION}.el6 $FPMRPMARGS .)

# Suse
  (cd beuser/suse/9/i386 ; fpm -a noarch --iteration ${ITERATION}.suse9 $FPMRPMARGS .)
  mv packages/${NAME}-${VERSION}-${ITERATION}.suse9.noarch.rpm packages/${NAME}-${VERSION}-${ITERATION}.suse9.i386.rpm 
  (cd beuser/suse/10/i386 ; fpm -a noarch --iteration ${ITERATION}.suse10 $FPMRPMARGS .)
  mv packages/${NAME}-${VERSION}-${ITERATION}.suse10.noarch.rpm packages/${NAME}-${VERSION}-${ITERATION}.suse10.i586.rpm 
  (cd beuser/suse/11/i386 ; fpm -a noarch --iteration ${ITERATION}.suse11 $FPMRPMARGS .)
  mv packages/${NAME}-${VERSION}-${ITERATION}.suse11.noarch.rpm packages/${NAME}-${VERSION}-${ITERATION}.suse11.i586.rpm 
  (cd beuser/suse/10/x86_64 ; fpm --iteration ${ITERATION}.suse10 $FPMRPMARGS .)
  (cd beuser/suse/11/x86_64 ; fpm --iteration ${ITERATION}.suse11 $FPMRPMARGS .)

# Ubuntu
  (cd beuser/ubuntu/12.04/x86_64 ; fpm --iteration ${ITERATION}.precise $FPMDEBARGS .)
  mv beuser/ubuntu/12.04/x86_64/*.deb packages/
  (cd beuser/ubuntu/13.04/x86_64 ; fpm --iteration ${ITERATION}.raring $FPMDEBARGS .)
  mv beuser/ubuntu/13.04/x86_64/*.deb packages/

# Solaris
  (cd beuser/solaris/10/x86_64/usr/bin ; fpm $FPMSOLARGS beuser)
  mv beuser/solaris/10/x86_64/usr/bin/beuser.solaris packages/beuser-${VERSION}-${ITERATION}.sol10.x86.pkg
  (cd beuser/solaris/10/sparc/usr/bin ; fpm $FPMSOLARGS beuser)
  mv beuser/solaris/10/sparc/usr/bin/beuser.solaris packages/beuser-${VERSION}-${ITERATION}.sol10.sparc.pkg
