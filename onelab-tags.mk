# build-GITPATH is now set by vbuild-nightly.sh to avoid duplication

###
linux-2.6-BRANCH		:= 32
linux-2.6-GITPATH               := git://git.onelab.eu/linux-2.6.git@linux-2.6-32-36
# help out spec2make on f8 and centos5, due to a bug in rpm 
# ditto on f16 for spec2make.py - tmp hopefully
ifeq "$(DISTRONAME)" "$(filter $(DISTRONAME),f8 f16 centos5)"
kernel-WHITELIST-RPMS	:= kernel-devel,kernel-headers
endif
kernel-DEVEL-RPMS		+= elfutils-libelf-devel

ipfw-GITPATH                    := git://git.code.sf.net/p/dummynet/code@ipfw-20130423-1
madwifi-GITPATH                 := git://git.onelab.eu/madwifi.git@madwifi-4132-6
iptables-GITPATH                := git://git.onelab.eu/iptables.git@iptables-1.4.10-5
###
comgt-SVNPATH			:= http://svn.onelab.eu/comgt/imports/0.3
planetlab-umts-tools-GITPATH    := git://git.onelab.eu/planetlab-umts-tools.git@planetlab-umts-tools-0.6-6
util-vserver-GITPATH            := git://git.onelab.eu/util-vserver.git@util-vserver-0.30.216-21
libnl-GITPATH			:= git://git.onelab.eu/libnl.git@libnl-1.1-2
util-vserver-pl-GITPATH         := git://git.onelab.eu/util-vserver-pl.git@util-vserver-pl-0.4-28
nodeupdate-GITPATH              := git://git.onelab.eu/nodeupdate.git@nodeupdate-0.5-9
PingOfDeath-SVNPATH		:= http://svn.planet-lab.org/svn/PingOfDeath/tags/PingOfDeath-2.2-1
plnode-utils-GITPATH            := git://git.onelab.eu/plnode-utils.git@plnode-utils-0.2-2
nodemanager-GITPATH             := git://git.onelab.eu/nodemanager.git@nodemanager-5.2-1
pl_sshd-SVNPATH			:= http://svn.planet-lab.org/svn/pl_sshd/tags/pl_sshd-1.0-11
codemux-GITPATH			:= git://git.onelab.eu/codemux.git@codemux-0.1-15
fprobe-ulog-GITPATH             := git://git.onelab.eu/fprobe-ulog.git@fprobe-ulog-1.1.4-2
pf2slice-SVNPATH		:= http://svn.planet-lab.org/svn/pf2slice/tags/pf2slice-1.0-2
mom-GITPATH                     := git://git.onelab.eu/mom.git@mom-2.3-5
inotify-tools-SVNPATH		:= http://svn.planet-lab.org/svn/inotify-tools/tags/inotify-tools-3.13-2
vsys-GITPATH                    := git://git.onelab.eu/vsys.git@vsys-0.99-3
vsys-scripts-GITPATH            := git://git.onelab.eu/vsys-scripts.git@vsys-scripts-0.95-46
autoconf-GITPATH		:= git://git.onelab.eu/autoconf@autoconf-2.69-1
sliver-openvswitch-GITPATH      := git://git.onelab.eu/sliver-openvswitch.git@master
plcapi-GITPATH                  := git://git.onelab.eu/plcapi.git@plcapi-5.2-2
drupal-GITPATH                  := git://git.onelab.eu/drupal.git@drupal-4.7-15
plewww-GITPATH                  := git://git.onelab.eu/plewww.git@plewww-5.2-2
www-register-wizard-SVNPATH     := http://svn.planet-lab.org/svn/www-register-wizard/tags/www-register-wizard-4.3-5
pcucontrol-GITPATH              := git://git.onelab.eu/pcucontrol.git@pcucontrol-1.0-13
monitor-GITPATH                 := git://git.onelab.eu/monitor.git@monitor-3.1-6
PLCRT-SVNPATH			:= http://svn.planet-lab.org/svn/PLCRT/tags/PLCRT-1.0-11
pyopenssl-GITPATH               := git://git.onelab.eu/pyopenssl.git@pyopenssl-0.9-2
###
pyaspects-GITPATH               := git://git.onelab.eu/pyaspects.git@pyaspects-0.4.1-3
omf-GITPATH                     := git://git.onelab.eu/omf.git@omf-5.3-11
oml-GITPATH                     := git://git.onelab.eu/oml.git@oml-2.6.1-1
###
nodeconfig-GITPATH              := git://git.onelab.eu/nodeconfig.git@nodeconfig-5.2-2
bootmanager-GITPATH             := git://git.onelab.eu/bootmanager.git@bootmanager-5.2-1
pypcilib-GITPATH                := git://git.onelab.eu/pypcilib.git@pypcilib-0.2-11
pyplnet-GITPATH                 := git://git.onelab.eu/pyplnet.git@pyplnet-4.3-16
bootcd-GITPATH                  := git://git.onelab.eu/bootcd.git@bootcd-5.2-2
sliceimage-GITPATH              := git://git.onelab.eu/sliceimage.git@master
nodeimage-GITPATH               := git://git.onelab.eu/nodeimage.git@nodeimage-5.2-1
myplc-GITPATH                   := git://git.onelab.eu/myplc.git@myplc-5.2-3
DistributedRateLimiting-SVNPATH	:= http://svn.planet-lab.org/svn/DistributedRateLimiting/tags/DistributedRateLimiting-0.1-1

#
sfa-GITPATH                     := git://git.onelab.eu/sfa.git@sfa-2.1-25
sface-GITPATH                   := git://git.onelab.eu/sface.git@sface-0.9-9
#
myslice-GITPATH			:= git://git.onelab.eu/myslice-django.git@master
manifold-GITPATH		:= git://git.onelab.eu/manifold.git@packaging
# locating the right test directory - see make tests_gitpath
tests-GITPATH                   := git://git.planet-lab.org/tests.git@master
