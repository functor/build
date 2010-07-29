# build-GITPATH is now set by vbuild-nightly.sh to avoid duplication

linux-2.6-GITPATH		:= git://git.planet-lab.org/linux-2.6.git@rhel6
madwifi-SVNPATH			:= http://svn.planet-lab.org/svn/madwifi/tags/madwifi-4099-0
iptables-SVNPATH                := http://svn.planet-lab.org/svn/iptables/tags/iptables-1.4.8-0
iptables-BUILD-FROM-SRPM := yes	# tmp
iproute2-GITPATH		:= git://git.planet-lab.org/iproute2.git@iproute2-2.6.33-2
iproute-BUILD-FROM-SRPM := yes	# tmp
util-vserver-GITPATH		:= git://git.planet-lab.org/util-vserver.git@util-vserver-0.30.216-5
util-vserver-BUILD-FROM-SRPM := yes	# tmp
libnl-SVNPATH			:= http://svn.planet-lab.org/svn/libnl/tags/libnl-1.1-2
util-vserver-pl-GITPATH		:= git://git.planet-lab.org/util-vserver-pl.git@util-vserver-pl-0.4-17
nodeupdate-GITPATH		:= git://git.planet-lab.org/nodeupdate.git@NodeUpdate-0.5-6
PingOfDeath-SVNPATH		:= http://svn.planet-lab.org/svn/PingOfDeath/tags/PingOfDeath-2.2-1
nodemanager-GITPATH             := git://git.planet-lab.org/nodemanager.git@nodemanager-2.0-17
# Trellis-specific NodeManager plugins
NodeManager-topo-SVNPATH	:= http://svn.planet-lab.org/svn/NodeManager-topo/trunk
NodeManager-optin-SVNPATH	:= http://svn.planet-lab.org/svn/NodeManager-optin/trunk
pl_sshd-SVNPATH			:= http://svn.planet-lab.org/svn/pl_sshd/tags/pl_sshd-1.0-11
codemux-GITPATH			:= git://git.planet-lab.org/codemux.git@CoDemux-0.1-14
fprobe-ulog-SVNPATH             := http://svn.planet-lab.org/svn/fprobe-ulog/tags/fprobe-ulog-1.1.3-2
pf2slice-SVNPATH		:= http://svn.planet-lab.org/svn/pf2slice/tags/pf2slice-1.0-2
Mom-SVNPATH			:= http://svn.planet-lab.org/svn/Mom/tags/Mom-2.3-2
inotify-tools-SVNPATH		:= http://svn.planet-lab.org/svn/inotify-tools/tags/inotify-tools-3.13-2
vsys-BRANCH			:= 0.9
vsys-GITPATH			:= git://git.planet-lab.org/vsys.git@vsys-0.9-5
vsys-scripts-GITPATH		:= git://git.planet-lab.org/vsys-scripts@vsys-scripts-0.95-20
plcapi-GITPATH                  := git://git.planet-lab.org/plcapi@plcapi-5.0-15
drupal-SVNPATH			:= http://svn.planet-lab.org/svn/drupal/tags/drupal-4.7-14
plewww-GITPATH			:= git://git.planet-lab.org/plewww@plewww-4.3-47
www-register-wizard-SVNPATH	:= http://svn.planet-lab.org/svn/www-register-wizard/tags/www-register-wizard-4.3-3
pcucontrol-GITPATH              := git://git.planet-lab.org/pcucontrol.git@pcucontrol-1.0-8
Monitor-SVNPATH			:= http://svn.planet-lab.org/svn/Monitor/tags/Monitor-3.0-35
PLCRT-SVNPATH			:= http://svn.planet-lab.org/svn/PLCRT/tags/PLCRT-1.0-11
pyopenssl-SVNPATH		:= http://svn.planet-lab.org/svn/pyopenssl/tags/pyopenssl-0.9-1
###
pyaspects-GITPATH		:= git://git.planet-lab.org/pyaspects.git@pyaspects-0.4.1-0
ejabberd-GITPATH		:= git://git.planet-lab.org/ejabberd.git@ejabberd-2.1.3-1
omf-GITPATH                     := git://git.planet-lab.org/omf.git@omf-5.3-7
###
sfa-SVNPATH			:= http://svn.planet-lab.org/svn/sfa/tags/sfa-0.9-14
nodeconfig-SVNPATH		:= http://svn.planet-lab.org/svn/nodeconfig/tags/nodeconfig-5.0-2
bootmanager-GITPATH             := git://git.planet-lab.org/bootmanager.git@bootmanager-5.0-8
pypcilib-GITPATH		:= git://git.planet-lab.org/pypcilib.git@pypcilib-0.2-9
pyplnet-GITPATH			:= git://git.planet-lab.org/pyplnet.git@pyplnet-4.3-6
bootcd-GITPATH                  := git://git.planet-lab.org/bootcd.git@BootCD-5.0-4
vserver-reference-GITPATH        := git://git.planet-lab.org/vserver-reference.git@VserverReference-5.0-3
bootstrapfs-GITPATH             := git://git.planet-lab.org/bootstrapfs.git@BootstrapFS-2.0-6
myplc-GITPATH                   := git://git.planet-lab.org/myplc.git@myplc-5.0-9
DistributedRateLimiting-SVNPATH	:= http://svn.planet-lab.org/svn/DistributedRateLimiting/tags/DistributedRateLimiting-0.1-1

# locating the right test directory - see make tests_gitpath
tests-GITPATH                   := git://git.planet-lab.org/tests.git@tests-5.0-14
