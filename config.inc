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
BITCHK=`getconf LONG_BIT`
#BITCHK="32"

### Multithread build
BUILD_MTS="-j$(expr $(nproc) \+ 1)"

#########################
### Select add module ###
#########################

### If you do not want to build modules, please enter a value other than "y".

### PageSpeed
PAGESPEED="y"

### nginx-rtmp-module
RTMP="y"

### naxsi
NAXSI="y"

### nginx-dav-ext-module
DAV_EXT="y"

### fancyindex
FANCYINDEX="y"
