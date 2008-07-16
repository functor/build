#!/bin/bash
# this can help you create/update your fedora mirror
# $Id$

COMMAND=$(basename $0)

dry_run=
verbose=
skip_core=
root=/mirror/

us_fedora_url=rsync://mirrors.kernel.org/fedora
# change this
us_centos_url=rsync://mirrors.rit.edu/centos

eu_fedora_url=rsync://ftp-stud.hs-esslingen.de/fedora/linux
eu_centos_url=rsync://mirrors.ircam.fr/CentOS

# change this
jp_fedora_url="need-to-be-defined"
# change this
jp_centos_url="need-to-be-defined"

default_distroname=f8
all_distronames="f7 f8 f9 centos5.1 centos5.2"
default_arch=i386
all_archs="i386 x86_64"

case $(hostname) in 
    *.fr|*.de|*.uk)
	fedora_url=$eu_fedora_url ; centos_url=$eu_centos_url ;;
    *.jp)
	fedora_url=$jp_fedora_url ; centos_url=$jp_centos_url ;;
    *)
	fedora_url=$us_fedora_url ; centos_url=$us_centos_url ;;
esac

function mirror_distro_arch () {
    distroname=$1; shift
    arch=$1; shift

    distroname=$(echo $distroname | tr '[A-Z]' '[a-z]')
    case $distroname in
	fc*[1-6])
    	    distroindex=$(echo $distroname | sed -e "s,fc,,g")
	    distro="Fedora Core"
	    rsyncurl=$fedora_url
	    ;;
	f*[7-9])
	    distroindex=$(echo $distroname | sed -e "s,f,,g")
	    distro="Fedora"
	    rsyncurl=$fedora_url
	    ;;
	centos[4-5]|centos[4-5].[0-9])
	    distroindex=$(echo $distroname | sed -e "s,centos,,g")
	    distro="CentOS"
	    rsyncurl=$centos_url
	    ;;
	*)
	    echo "WARNING -- Unknown distribution $distroname -- skipped"
	    return 1
	    ;;
    esac

    excludelist="debug/ iso/ ppc/ source/"
    options="--archive --compress --delete --delete-excluded $dry_run $verbose"
    [ -n "$(rsync --help | grep no-motd)" ] && options="$options --no-motd"
    for e in $excludelist; do
	options="$options --exclude $e"
    done

    if [ -n "$verbose" ] ; then 
	echo "root=$root"
	echo "distro=$distroname"
	echo "distroname=$distroname"
	echo "distroindex=$distroindex"
	echo "arch=$arch"
	echo rsyncurl="$rsyncurl"
	echo "rsync options=$options"
    fi

    RES=1
    paths=""
    case $distro in
	[Ff]edora*)
            case $distroindex in
		2|4|6)
		    [ -z "$skip_core" ] && paths="core/$distroindex/$arch/os/"
		    paths="$paths core/updates/$distroindex/$arch/ extras/$distroindex/$arch/"
		    RES=0
		    ;;
		[7-9])
		    [ -z "$skip_core" ] && paths="releases/$distroindex/Everything/$arch/os/"
		    paths="$paths updates/$distroindex/$arch/"
		    RES=0
		    ;;
	    esac
	    localpath=fedora
	    ;;
    
	CentOS*)
	    case $distroindex in
		5*)
		    [ -z "$skip_core" ] && paths="$distroindex/os/$arch/"
		    paths="$paths $distroindex/updates/$arch/"
		    RES=0
		    ;;
	    esac
	    localpath=centos
	    ;;

    esac

    if [ "$RES" = 1 ] ; then
	echo "DISTRIBUTION $distro $distroindex CURRENTLY UNSUPPORTED - skipped"
    else
	for repopath in $paths; do
	    echo "============================== $distro -> $distroindex $repopath"
	    [ -z "$dry_run" ] && mkdir -p ${root}/${localpath}/${repopath}
	    command="rsync $options ${rsyncurl}/${repopath} ${root}/${localpath}/${repopath}"
	    echo $command
	    $command
	done
    fi

    return $RES 
}

function usage () {
    echo "Usage: $COMMAND [-n] [-v] [-c] [-r root] [-u|U rsyncurl] [-e|-j] [-f distroname|-F] [-a arch|-A]"
    echo "Defaults to -r $root -u $rsyncurl -f $default_distroname -a $default_arch"
    echo "Options:"
    echo " -n : dry run"
    echo " -v : verbose"
    echo " -c : skips core repository"
    echo " -r root (default is $root)"
    echo " -u rsyncurl for fedora (default is $fedora_url)"
    echo " -U rsyncurl for centos (default is $centos_url)"
    echo " -e : uses European mirrors $eu_fedora_url $eu_centos_url"
    echo " -j : uses Japanese mirrors $jp_fedora_url $jp_centos_url"
    echo " -f distroname - use vserver convention, e.g. fc6 and f7"
    echo " -F : for distroname in $all_distronames"
    echo " -a arch - use yum convention"
    echo " -A : for arch in $all_archs"
    exit 1
}

function main () {
    distronames=""
    archs=""
    while getopts "nvcr:u:U:ef:Fa:Ah" opt ; do
	case $opt in
	    n) dry_run=--dry-run ; verbose=--verbose ;;
	    v) verbose=--verbose ;;
	    c) skip_core=true ;;
	    r) root=$OPTARG ;;
	    u) fedora_url=$OPTARG ;;
	    U) centos_url=$OPTARG ;;
	    e) fedora_url=$eu_fedora_url ; centos_url=$eu_centos_url ;;
	    j) fedora_url=$jp_fedora_url ; centos_url=$jp_centos_url ;;
	    f) distronames="$distronames $OPTARG" ;;
	    F) distronames="$distronames $all_distronames" ;;
	    a) archs="$archs $OPTARG" ;;
	    A) archs="$archs $all_archs" ;;
	    h|*) usage ;;
	esac
    done
    [ -z "$distronames" ] && distronames=$default_distroname
    [ -z "$archs" ] && archs=$default_arch

    RES=0
    for distroname in $distronames ; do 
	for arch in $archs; do 
	    mirror_distro_arch "$distroname" "$arch" || RES=1
	done
    done

    exit $RES
}

main "$@"
