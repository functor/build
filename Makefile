#
# PlanetLab RPM generation
#
# Copyright (c) 2003  The Trustees of Princeton University (Trustees).
# All Rights Reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met: 
# 
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
# 
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
# 
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE TRUSTEES OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# $Id$
#

#
# CVSROOT: CVSROOT to use
# INITIAL: CVS tag to use for Source0 tarball
# TAG: CVS tag to patch to
# MODULE: CVS module name to use
# SPEC: RPM spec file template
# RPMFLAGS: Miscellaneous RPM flags
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

#
# kernel-planetlab
#

kernel-planetlab-CVSROOT := pup-pl_kernel@cvs.planet-lab.org:/cvs
kernel-planetlab-INITIAL := linux-2_4_22
kernel-planetlab-TAG := HEAD
kernel-planetlab-MODULE := linux-2.4
kernel-planetlab-SPEC := linux-2.4/scripts/kernel-planetlab.spec
ALL += kernel-planetlab

#
# plkmod
#

plkmod-CVSROOT := pup-silk@cvs.planet-lab.org:/cvs
plkmod-INITIAL := HEAD
plkmod-TAG := HEAD
plkmod-MODULE := sys-v3
plkmod-SPEC := sys-v3/rpm/plkmod.spec
plkmod-RPMFLAGS = --define "kernelver $(shell rpmquery --queryformat '%{VERSION}-%{RELEASE}\n' --specfile SPECS/$(notdir $(kernel-planetlab-SPEC)) | head -1)"
ALL += plkmod

# Build kernel-planetlab first so we can bootstrap off of its build
plkmod: kernel-planetlab

#
# vdk
#

vdk-CVSROOT := pup-pl_kernel@cvs.planet-lab.org:/cvs
vdk-INITIAL := vdk_918
vdk-TAG := HEAD
vdk-MODULE := vdk
vdk-SPEC := vdk/vtune_driver.spec
vdk-RPMFLAGS = --define "kernelver $(shell rpmquery --queryformat '%{VERSION}-%{RELEASE}\n' --specfile SPECS/$(notdir $(kernel-planetlab-SPEC)) | head -1)"
ALL += vdk

# Build kernel-planetlab first so we can bootstrap off of its build
vdk: kernel-planetlab

ifeq ($(findstring $(package),$(ALL)),)

# Build all packages
all: $(ALL)

# Recurse
$(ALL):
	$(MAKE) package=$@ all

.PHONY: all $(ALL)

else

# Define variables for Makerules
CVSROOT := $($(package)-CVSROOT)
INITIAL := $($(package)-INITIAL)
TAG := $($(package)-TAG)
MODULE := $($(package)-MODULE)
SPEC := $($(package)-SPEC)
RPMFLAGS := $($(package)-RPMFLAGS)
CVS_RSH := $(if $($(package)-CVS_RSH),$($(package)-CVS_RSH),ssh)

include Makerules

endif

# Remove generated files
clean:
	rm -rf BUILD RPMS SOURCES SPECS SRPMS .rpmmacros .cvsps

.PHONY: clean
