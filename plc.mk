#
# PlanetLab Central local RPM generation
#
# Mark Huang <mlhuang@cs.princeton.edu>
# Copyright (C) 2003-2005 The Trustees of Princeton University
#
# $Id: plc.mk,v 1.2.2.1 2005/05/17 21:33:51 mlhuang Exp $
#

# Default target
all:

#
# CVSROOT: CVSROOT to use
# INITIAL: CVS tag to use for Source0 tarball
# TAG: CVS tag to patch to (if not HEAD)
# MODULE: CVS module name to use (if not HEAD)
# SPEC: RPM spec file template
# RPMFLAGS: Miscellaneous RPM flags
# CVS_RSH: If not ssh
# ALL: default targets
#
# If INITIAL is different than TAG, PatchSets will be generated
# automatically with cvsps(1) to bring Source0 up to TAG. If TAG is
# HEAD, a %{date} variable will be defined in the generated spec
# file. If a Patch: tag in the spec file matches a generated PatchSet
# number, the name of the patch will be as specified. Otherwise, the
# name of the patch will be the PatchSet number. %patch tags in the
# spec file are generated automatically.
#

# Default values
INITIAL := plc-0_2-2
TAG := plc-0_2-2
CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs

#
# plc
#

plc-CVSROOT := :ext:cvs.planet-lab.org:/cvs
plc-MODULE := plc
plc-SPEC := plc/plc.spec
ALL += plc

#
# Proper: Privileged Operations Service
#

proper-CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs
proper-MODULE := proper
proper-SPEC := proper/proper.spec
ALL += proper

#
# ulogd
#

ulogd-CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs
ulogd-MODULE := ulogd
ulogd-SPEC := ulogd/ulogd.spec
ALL += ulogd

ulogd: proper

#
# netflow
#

netflow-CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs
netflow-MODULE := netflow
netflow-SPEC := netflow/netflow.spec
ALL += netflow

#
# Request Tracker 3
#

rt3-CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs
rt3-MODULE := rt3
rt3-SPEC := rt3/etc/rt.spec
ALL += rt3

#
# Mail::SpamAssassin
#

spamassassin-CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs
spamassassin-MODULE := spamassassin
spamassassin-SPEC := spamassassin/spamassassin.spec
ALL += spamassassin

#
# TWiki
#

twiki-CVSROOT := :pserver:anon@cvs.planet-lab.org:/cvs
twiki-MODULE := twiki
twiki-SPEC := twiki/TWiki.spec
ALL += twiki

ifeq ($(findstring $(package),$(ALL)),)

# Build all packages
all: $(ALL)
	cvs -d $(CVSROOT) checkout -p alpina/groups/stock_fc2_groups.xml > RPMS/yumgroups.xml

# Recurse
$(ALL):
	$(MAKE) -f plc.mk package=$@

# Put packages in boot repository
ARCHIVE := /var/www/html/archive

# Put nightly alpha builds in a subdirectory
ifeq ($(TAG),HEAD)
ARCHIVE := $(ARCHIVE)/plc-alpha
REPOS := /var/www/html/plc-alpha
endif

install:
ifeq ($(BASE),)
	@echo make install is only meant to be called from ./build.sh
else
ifneq ($(BUILDS),)
        # Remove old runs
	cd $(ARCHIVE) && ls -t | sed -n $(BUILDS)~1p | xargs rm -rf
endif
        # Populate repository
	mkdir -p $(ARCHIVE)/$(BASE)
	rsync --links --perms --times --group \
	    $(sort $(subst -debuginfo,,$(wildcard RPMS/yumgroups.xml RPMS/*/*))) $(ARCHIVE)/$(BASE)/
	yum-arch $(ARCHIVE)/$(BASE) >/dev/null
ifeq ($(TAG),HEAD)
	ln -nsf $(ARCHIVE)/$(BASE) $(REPOS)
endif
endif

# Remove files generated by this package
$(foreach package,$(ALL),$(package)-clean): %-clean:
	$(MAKE) -f plc.mk package=$* clean

# Remove all generated files
clean:
	rm -rf BUILD RPMS SOURCES SPECS SRPMS .rpmmacros .cvsps

.PHONY: all $(ALL) $(foreach package,$(ALL),$(package)-clean) clean

else

# Define variables for Makerules
CVSROOT := $(if $($(package)-CVSROOT),$($(package)-CVSROOT),$(CVSROOT))
INITIAL := $(if $($(package)-INITIAL),$($(package)-INITIAL),$(INITIAL))
TAG := $(if $($(package)-TAG),$($(package)-TAG),$(TAG))
MODULE := $($(package)-MODULE)
SPEC := $($(package)-SPEC)
RPMFLAGS := $($(package)-RPMFLAGS)
CVS_RSH := $(if $($(package)-CVS_RSH),$($(package)-CVS_RSH),ssh)

include Makerules

endif
