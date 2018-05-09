#!/bin/sh

### Please install library.
### CentOS / Red Hat - yum install jemalloc-devel libuuid-devel libatomic libatomic_ops-devel expat-devel unzip autoconf automake libtool gd-devel geoip-devel gcc-c++
### Ubuntu / Debian - apt install libjemalloc-dev uuid-dev libatomic1 libatomic-ops-dev expat unzip autoconf automake libtool libgd-dev libgeoip-dev g++

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

##########################
### nginx install path ###
##########################

### Prefix
NGX_PREFIX="/usr/local/nginx"

### Binary
NGX_SBIN_PATH="/usr/sbin/nginx"

### Config Path
NGX_CONF="/etc/nginx/nginx.conf"

### Temp Path (client_body_temp, proxy_temp, ...)
NGX_LIB="/var/lib/nginx"

### Log path
NGX_LOG="/var/log/nginx"

### PID file
NGX_PID="/var/run/nginx.pid"

### Lock file
NGX_LOCK="/var/lock/nginx.lock"
