#!/bin/bash
#
# PlanetLab release build script. Intended to be used by scripts and
# crontabs to build nightly releases (default). Can also be invoked
# manually to build a tagged release (-r) in the current directory.
#
# Mark Huang <mlhuang@cs.princeton.edu>
# Copyright (C) 2003-2005 The Trustees of Princeton University
#
# $Id: build.sh,v 1.35 2006/07/06 14:57:50 mlhuang Exp $
#

# Set defaults
CVSROOT=:pserver:anon@cvs.planet-lab.org:/cvs
CVS_RSH=ssh
MODULE=build
TAG=HEAD
BASE=$PWD
PLDISTRO=planetlab

# cron does not set USER?
[ -z "$USER" ] && export USER=$LOGNAME

# Export certain variables
export CVS_RSH

# Get options
while getopts "d:r:m:f:b:x:h" opt ; do
    case $opt in
	d)
	    CVSROOT=$OPTARG
	    ;;
	r)
	    TAG=$OPTARG
	    ;;
	m)
	    MAILTO=$OPTARG
	    ;;
	f)
	    PLDISTRO="$OPTARG"
	    ;;
	b)
	    BASE=$OPTARG
	    ;;
	x)
	    BUILDS=$OPTARG
	    ;;
	h|*)
	    echo "usage: `basename $0` [OPTION]..."
	    echo "	-d directory	CVS repository root (default $CVSROOT)"
	    echo "	-r revision	CVS revision to checkout (default $TAG)"
	    echo "	-m address	Notify recipient of failures (default: none)"
	    echo "	-f distro	Distribution to build (default: $PLDISTRO)"
	    echo "	-b base		Run operations in specified base directory (default $BASE)"
	    echo "	-x N		Remove all but the last N runs from the base directory (default: none)"
	    exit 1
	    ;;
    esac
done
shift $(($OPTIND - 1))

# Base operations in specified directory
mkdir -p $BASE
cd $BASE || exit $?

# Remove old runs
if [ -n "$BUILDS" ] ; then
    ls -t | sed -n ${BUILDS}~1p | xargs rm -rf
fi

# Create a unique build base
BASE=${TAG/HEAD/`date +%Y.%m.%d`}
i=
while ! mkdir ${BASE}${i} 2>/dev/null ; do
    [ -z ${i} ] && BASE=${BASE}.
    i=$((${i}+1))
    if [ $i -gt 100 ] ; then
	echo "$0: Failed to create release directory `pwd`/${BASE}${i}"
	exit 1
    fi
done
BASE=${BASE}${i}

# Redirect output from here
exec 2>&1
exec &>${BASE}/log

# Build
cvs -d ${CVSROOT} checkout -r ${TAG} -d ${BASE} ${MODULE}
make TAG=${TAG} PLDISTRO=${PLDISTRO} -C ${BASE} && \
make TAG=${TAG} PLDISTRO=${PLDISTRO} -C ${BASE} install BASE=$BASE BUILDS=$BUILDS
rc=$?

if [ $rc -ne 0 ] ; then
    # Notify recipient of failure
    if [ -n "$MAILTO" ] ; then
	tail -c 8k ${BASE}/log | mail -s "Failures for ${BASE}" $MAILTO
    fi
    exit $rc
fi

exit 0
