#
# PlanetLab standard components list
#
# Mark Huang <mlhuang@cs.princeton.edu>
# Copyright (C) 2003-2006 The Trustees of Princeton University
#
# $Id: planetlab.mk,v 1.71 2007/09/25 18:38:47 faiyaza Exp $
#

#
# Required:
#
# CVSROOT or package-CVSROOT: CVSROOT to use
# or
# SVNPATH or package-SVNPATH: SVNPATH to use
# Note: do not define both CVSROOT and SVNPATH
#
# TAG or package-TAG: CVS/SVN tag to use
# package-MODULE: CVS/SVN module name to use
# package-SPEC: RPM spec file template
#
# Optional:
#
# package-RPMFLAGS: Miscellaneous RPM flags
# package-RPMBUILD: If not rpmbuild
# package-CVS_RSH: If not ssh for cvs
#
# Add to ALL if you want the package built as part of the default set.
#

#
# Default values -- should be able to override these from command line
#

HOSTARCH := $(shell uname -i)
DISTRO := $(shell ./getdistro.sh)
RELEASE := $(shell ./getrelease.sh)

#
# load in a release specific tags file
# Override TAGSFILE from command line to select something else
#
TAGSFILE = default-tags.mk
include $(TAGSFILE)


#
# kernel
#

kernel-$(HOSTARCH)-MODULE := Linux-2.6
kernel-$(HOSTARCH)-SPEC := scripts/kernel-2.6-planetlab.spec
ifeq ($(HOSTARCH),i386)
kernel-$(HOSTARCH)-RPMFLAGS:= --target i686
else
kernel-$(HOSTARCH)-RPMFLAGS:= --target $(HOSTARCH)
endif

ALL += kernel-$(HOSTARCH)

kernel-clean: kernel-$(HOSTARCH)-clean
kernel: kernel-$(HOSTARCH)

#
# util-vserver
#

util-vserver-MODULE := util-vserver
util-vserver-SPEC := util-vserver.spec
util-vserver-RPMFLAGS:= --without dietlibc
ALL += util-vserver

#
# NodeUpdate
#

NodeUpdate-MODULE := NodeUpdate
NodeUpdate-SPEC := NodeUpdate.spec
ALL += NodeUpdate

#
# PlanetLabConf:  DEPRECATED.  
#
# conf_files does the same thing in NM
#

#PlanetLabConf-MODULE := PlanetLabConf
#PlanetLabConf-SPEC := PlanetLabConf/PlanetLabConf.spec
#ALL += PlanetLabConf

#
# ipod
#

PingOfDeath-MODULE := PingOfDeath
PingOfDeath-SPEC := ipod.spec
ALL += PingOfDeath

#
# sudo:  DEPRECATED
#
# Added functionality provided by this package to www/PlanetLabConf/sudoers.
#

#sudo-MODULE := sudo
#sudo-SPEC := sudo/planetlab_sudo.spec
#ALL += sudo

#
# pycurl:  DEPRECATE
#
# [tony] use FC6+ release
#

#curl_vernum := $(shell printf %d 0x$(shell curl-config --vernum))
#pycurl_vernum := $(shell printf %d 0x070d01) # 7.13.1
#pycurl_incompatnum := $(shell printf %d 0x071000) # 7.16.0
#ifeq ($(shell test $(curl_vernum) -ge $(pycurl_vernum) && echo 1),1)
#ifeq ($(shell test $(curl_vernum) -ge $(pycurl_incompatnum) && echo 0),1)
#pycurl-MODULE := pycurl
#pycurl-SPEC := pycurl/pycurl.spec
#ALL += pycurl
#endif
#endif

#
# BootServerRequest:  DEPRECATE
#
# Not used by anything.
#

#BootServerRequest-MODULE := BootServerRequest
#BootServerRequest-SPEC := BootServerRequest/PLBootServerRequest.spec
#ALL += BootServerRequest
#
#
#
# Node Manager
#

NodeManager-MODULE := NodeManager
NodeManager-SPEC := NodeManager.spec
ALL += NodeManager

#
# pl_sshd
#

pl_sshd-MODULE := pl_sshd
pl_sshd-SPEC := pl_sshd.spec
ALL += pl_sshd

#
# libhttpd++: 
#
# Deprecate when vsys takes over [sapan].
# keep in build for proper.
#

libhttpd++-MODULE := libhttpd++
libhttpd++-SPEC := libhttpd++.spec
ALL += libhttpd++

#
# Proper: Privileged Operations Service
#

proper-MODULE := proper
proper-SPEC := proper.spec
proper-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += proper

proper: libhttpd++

#
# CoDemux: Port 80 demux
#

CoDemux-MODULE := CoDemux
CoDemux-SPEC   := codemux.spec
CoDemux-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += CoDemux

#
# MySQL
#

mysql-MODULE := mysql
mysql-SPEC := mysql.spec
#ALL += mysql

#
# ulogd
#

ulogd-MODULE := ulogd
ulogd-SPEC := ulogd.spec
ALL += ulogd

ulogd: kernel proper #mysql

#
# netflow
#

PlanetFlow-MODULE := PlanetFlow
PlanetFlow-RPMFLAGS := --define "distroname '$(DISTRO)'" --define "distrorelease $(RELEASE)"
PlanetFlow-SPEC := netflow.spec
ALL += PlanetFlow

PlanetFlow: #mysql

#
# PlanetLab Mom: Cleans up your mess
#

Mom-MODULE := Mom
Mom-SPEC := pl_mom.spec
ALL += Mom

#
# iptables
#

iptables-MODULE := iptables
iptables-SPEC := iptables.spec
ALL += iptables

iptables: kernel

#
# iproute
#

iproute-MODULE := iproute2
iproute-SPEC := iproute.spec
ALL += iproute

#
# kexec-tools:  DEPRECATE
#
# [marc]    use FC6+ release
#

#kexec-tools-MODULE := kexec-tools
#kexec-tools-SPEC := kexec-tools/kexec-tools.spec
#ALL += kexec-tools

#
# util-python
#
# [marc]    deprecate with proper
#

util-python-MODULE := util-python
util-python-SPEC := util-python.spec
ALL += util-python

# proper uses scripts in util-python for building
proper: util-python

#
# vsys
#
vsys-MODULE := vsys
vsys-SPEC := vsys.spec
ifeq ($(DISTRO),"Fedora")
ifeq ($(RELEASE),7)
ALL += vsys
endif
endif


#
# PLCAPI
#

PLCAPI-MODULE := PLCAPI
PLCAPI-SPEC := PLCAPI.spec
ALL += PLCAPI

#
# PLCWWW
#

PLCWWW-MODULE := WWW
PLCWWW-SPEC := PLCWWW.spec
ALL += PLCWWW

#
# vserver-reference
#

VserverReference-MODULE := VserverReference build
VserverReference-SPEC := vserver-reference.spec
# Package must be built as root
VserverReference-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += VserverReference

# vserver-reference may require current packages
VserverReference: $(filter-out vserver-reference,$(ALL))

# ... and the groups manifest
VserverReference: RPMS/yumgroups.xml


#
# BootManager
#

BootManager-MODULE := BootManager build
BootManager-SPEC := bootmanager.spec
# Package must be built as root
BootManager-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += BootManager

#
# BootCD
#

BootCD-MODULE := BootCD BootManager build
BootCD-SPEC := bootcd.spec
BootCD-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += BootCD

#
# BootstrapFS
#

BootstrapFS-MODULE := BootstrapFS build
BootstrapFS-SPEC := bootstrapfs.spec
# Package must be built as root
BootstrapFS-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += BootstrapFS

# BootstrapFS requires current packages
BootstrapFS: $(filter-out BootstrapFS,$(ALL))

# ... and the groups manifest
BootstrapFS: RPMS/yumgroups.xml

#
# MyPLC
#

MyPLC-MODULE := MyPLC build WWW
MyPLC-SPEC := myplc.spec
# Package must be built as root
MyPLC-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += MyPLC

# MyPLC may require current packages
MyPLC: $(filter-out MyPLC,$(ALL))

# ...and the yum manifest
MyPLC: RPMS/yumgroups.xml


#
# MyPLC native
#

MyPLC-native-MODULE := MyPLC build WWW
MyPLC-native-SPEC := myplc-native.spec
# Package must be built as root
MyPLC-native-RPMBUILD := sudo bash ./rpmbuild.sh
ALL += MyPLC-native

# MyPLC may require current packages
MyPLC-native: $(filter-out MyPLC,$(ALL))

# ...and the yum manifest
MyPLC-native: RPMS/yumgroups.xml

#
# MyPLC development environment
#

MyPLC-devel-MODULE := MyPLC build 
MyPLC-devel-SPEC := myplc-devel.spec
# Package must be built as root
MyPLC-devel-RPMBUILD := sudo bash ./rpmbuild.sh
#ALL += MyPLC-devel

#
# MyPLC native development environment
#

MyPLC-devel-native-MODULE := MyPLC
MyPLC-devel-native-RPMFLAGS := --define "distroname '$(DISTRO)'" --define "distrorelease $(RELEASE)"
MyPLC-devel-native-SPEC := myplc-devel-native.spec
ALL += MyPLC-devel-native

#
# libnl
#
# [daniel]    wait for latest Fedora release 
# (03:29:46 PM) daniel_hozac: interfacing with the kernel directly when dealing with netlink was fugly, so... i had to find something nicer.
# (03:29:53 PM) daniel_hozac: the one in Fedora is lacking certain APIs i need.
#

libnl-MODULE := libnl
libnl-SPEC := libnl.spec
ALL += libnl

util-vserver: libnl

RPMS/yumgroups.xml:
	install -D -m 644 groups/v4_yumgroups.xml RPMS/yumgroups.xml

#XXX We need to rethink this installation support for several reasons:
# 1) it is pldistro specific
# 2) may involve installing files for different node groups (e.g., alpha, beta, etc.)
# 3) may involve N rpm repositories to where it should be uploaded
#
# Not clear to me at all that this should be incorporated into a
# Makefile at all.  Instead it should be something that gets wrapped
# into a myplc (sub) rpm package and then is installed by that way.

#
# Installation rules
# 

# Upload packages to boot server
SERVERA := build@boot1.planet-lab.org
SERVERB := build@boot2.planet-lab.org
ARCHIVE := /plc/data/var/www/html/install-rpms/archive

# Put nightly alpha builds in a subdirectory
ifeq ($(TAG),HEAD)
ARCHIVE := $(ARCHIVE)/planetlab-alpha
REPOS := /plc/data/var/www/html/install-rpms/planetlab-alpha
endif

install:
ifeq ($(BASE),)
	@echo make install is only meant to be called from ./build.sh
else
ifneq ($(wildcard /etc/planetlab/secring.gpg),)
        # Sign all RPMS. setsid detaches rpm from the terminal,
        # allowing the (hopefully blank) GPG password to be entered
        # from stdin instead of /dev/tty. Obviously, the build server
        # should be secure.
	echo | setsid rpm \
	--define "_signature gpg" \
	--define "_gpg_path /etc/planetlab" \
	--define "_gpg_name PlanetLab <info@planet-lab.org>" \
	--resign RPMS/*/*.rpm
endif
ifneq ($(BUILDS),)
        # Remove old runs
	echo "cd $(ARCHIVE) && ls -t | sed -n $(BUILDS)~1p | xargs rm -rf" | ssh $(SERVERA) /bin/bash -s
	echo "cd $(ARCHIVE) && ls -t | sed -n $(BUILDS)~1p | xargs rm -rf" | ssh $(SERVERB) /bin/bash -s
endif
        # Create package manifest
	sh ./packages.sh -b "http://build.planet-lab.org/$(subst $(HOME)/,,$(shell pwd))/RPMS" RPMS > packages.xml
        # Update yum metadata
	yum-arch RPMS >/dev/null
	createrepo -g yumgroups.xml RPMS >/dev/null
        # Populate repository
	rsync \
	--exclude '*-debuginfo-*' \
	--recursive --links --perms --times --group --compress --rsh=ssh \
	RPMS/ $(SERVERA):$(ARCHIVE)/$(BASE)
	rsync \
	--exclude '*-debuginfo-*' \
	--recursive --links --perms --times --group --compress --rsh=ssh \
	RPMS/ $(SERVERB):$(ARCHIVE)/$(BASE)
ifeq ($(TAG),HEAD)
        # Update nightly alpha symlink if it does not exist or is broken, or it is Monday
	if ! ssh $(SERVERA) "[ -e $(REPOS) ] && exit 0 || exit 1" || [ "$(shell date +%A)" = "Monday" ] ; then \
	    ssh $(SERVERA) ln -nsf archive/$(BASE) $(REPOS) ; \
	fi
        # Update nightly alpha symlink if it does not exist or is broken, or it is Monday
	if ! ssh $(SERVERB) "[ -e $(REPOS) ] && exit 0 || exit 1" || [ "$(shell date +%A)" = "Monday" ] ; then \
	    ssh $(SERVERB) ln -nsf archive/$(BASE) $(REPOS) ; \
	fi

endif
endif

.PHONY: install
