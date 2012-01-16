# build-GITPATH is now set by vbuild-nightly.sh to avoid duplication

###
linux-2.6-BRANCH		:= rhel6
linux-2.6-GITPATH               := git://git.onelab.eu/linux-2.6.git@32
# help out spec2make on f8 and centos5, due to a bug in rpm 
# ditto on f16 for spec2make.py - tmp hopefully
ifeq "$(DISTRONAME)" "$(filter $(DISTRONAME),f8 f16 centos5)"
kernel-WHITELIST-RPMS	:= kernel-devel,kernel-headers
endif
kernel-DEVEL-RPMS		+= elfutils-libelf-devel

madwifi-GITPATH                 := git://git.onelab.eu/madwifi.git@master
iptables-GITPATH                := git://git.onelab.eu/iptables.git@iptables-1.4.10-5
# we use the stock iproute2 with 2.6.32, since our gre patch is not needed anymore with that kernel
# note that this should be consistently reflected in pl_getKexcludes in build.common
ALL := $(filter-out iproute,$(ALL))
###
ipfw-GITPATH                    := git://git.onelab.eu/ipfw.git@ipfw-0.9-23
###
comgt-SVNPATH			:= http://svn.onelab.eu/comgt/imports/0.3
planetlab-umts-tools-GITPATH    := git://git.onelab.eu/planetlab-umts-tools.git@planetlab-umts-tools-0.6-6
util-vserver-GITPATH            := git://git.onelab.eu/util-vserver.git@util-vserver-0.30.216-19
libnl-GITPATH			:= git://git.onelab.eu/libnl.git@libnl-1.1-2
util-vserver-pl-GITPATH         := git://git.onelab.eu/util-vserver-pl.git@util-vserver-pl-0.4-26
nodeupdate-GITPATH              := git://git.onelab.eu/nodeupdate.git@nodeupdate-0.5-9
PingOfDeath-SVNPATH		:= http://svn.planet-lab.org/svn/PingOfDeath/tags/PingOfDeath-2.2-1
nodemanager-GITPATH             := git://git.onelab.eu/nodemanager.git@nodemanager-2.0-34
pl_sshd-SVNPATH			:= http://svn.planet-lab.org/svn/pl_sshd/tags/pl_sshd-1.0-11
codemux-GITPATH			:= git://git.onelab.eu/codemux.git@codemux-0.1-15
fprobe-ulog-SVNPATH             := http://svn.planet-lab.org/svn/fprobe-ulog/tags/fprobe-ulog-1.1.3-3
pf2slice-SVNPATH		:= http://svn.planet-lab.org/svn/pf2slice/tags/pf2slice-1.0-2
Mom-SVNPATH			:= http://svn.planet-lab.org/svn/Mom/tags/Mom-2.3-4
inotify-tools-SVNPATH		:= http://svn.planet-lab.org/svn/inotify-tools/tags/inotify-tools-3.13-2
openvswitch-GITPATH		:= git://git.onelab.eu/openvswitch.git@openvswitch-1.1.0pre2-2
vsys-GITPATH                    := git://git.onelab.eu/vsys.git@vsys-0.99-2
vsys-scripts-GITPATH            := git://git.onelab.eu/vsys-scripts.git@vsys-scripts-0.95-34
plcapi-GITPATH                  := git://git.onelab.eu/plcapi.git@plcapi-5.0-36
drupal-GITPATH                  := git://git.onelab.eu/drupal.git@drupal-4.7-15
plewww-GITPATH                  := git://git.onelab.eu/plewww.git@plewww-4.3-69
www-register-wizard-SVNPATH     := http://svn.planet-lab.org/svn/www-register-wizard/tags/www-register-wizard-4.3-5
pcucontrol-GITPATH              := git://git.onelab.eu/pcucontrol.git@pcucontrol-1.0-12
monitor-GITPATH                 := git://git.onelab.eu/monitor.git@monitor-3.1-6
PLCRT-SVNPATH			:= http://svn.planet-lab.org/svn/PLCRT/tags/PLCRT-1.0-11
pyopenssl-GITPATH               := git://git.onelab.eu/pyopenssl.git@pyopenssl-0.9-2
###
pyaspects-GITPATH               := git://git.onelab.eu/pyaspects.git@pyaspects-0.4.1-2
ejabberd-GITPATH                := git://git.onelab.eu/ejabberd.git@master
omf-GITPATH                     := git://git.onelab.eu/omf.git@omf-5.3-11
oml-GITPATH                     := git://git.onelab.eu/oml.git@oml-2.6.1-1
###
sfa-GITPATH                     := git://git.onelab.eu/sfa.git@sfa-2.0-9
sface-GITPATH                   := git://git.onelab.eu/sface.git@sface-0.9-3
nodeconfig-GITPATH              := git://git.onelab.eu/nodeconfig.git@nodeconfig-5.0-5
bootmanager-GITPATH             := git://git.planet-lab.org/bootmanager.git@lxcbuild
pypcilib-GITPATH		:= git://git.onelab.eu/pypcilib.git@pypcilib-0.2-10
pyplnet-GITPATH                 := git://git.onelab.eu/pyplnet.git@pyplnet-4.3-11
bootcd-GITPATH                  := git://git.onelab.eu/bootcd.git@bootcd-5.0-11
vserver-reference-GITPATH        := git://git.onelab.eu/vserver-reference.git@vserver-reference-5.0-6
bootstrapfs-GITPATH             := git://git.onelab.eu/bootstrapfs.git@bootstrapfs-2.0-13
myplc-GITPATH                   := git://git.onelab.eu/myplc.git@myplc-5.0-19
DistributedRateLimiting-SVNPATH	:= http://svn.planet-lab.org/svn/DistributedRateLimiting/tags/DistributedRateLimiting-0.1-1

# locating the right test directory - see make tests_gitpath
tests-GITPATH                   := git://git.onelab.eu/tests.git@master

