#!/bin/sh

### Please install library.
### CentOS / Red Hat - yum install jemalloc-devel libuuid-devel libatomic expat-devel unzip autoconf automake libtool
### Ubuntu / Debian - apt install libjemalloc-dev uuid-dev libatomic1 libatomic-ops-dev expat unzip autoconf automake libtool

######################
### Default Config ###
######################

### SERVER HEADER!!!
### Please edit this
SERVER_HEADER="hakase"

### x86, x64 check
### If you do not want optimization, uncomment it.
### (Comment out existing sources.)
### Do not modify it under normal circumstances.
BITCHK=`getconf LONG_BIT`
#BITCHK=32

### Multithread build
### Do not modify it under normal circumstances.
BUILD_MTS="-j$(expr $(nproc) \+ 1)"

#########################
### Select add module ###
#########################

### Enter 0 for the module that is not to be used.

### PageSpeed
PAGESPEED=1

### nginx-rtmp-module
RTMP=1

### naxsi
NAXSI=1

### nginx-dav-ext-module
DAV_EXT=1

### fancyindex
FANCYINDEX=1
