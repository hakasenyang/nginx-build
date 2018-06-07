#!/bin/sh

### Read config
if [ ! -f "config.inc" ]; then
    echo "--- The configuration file (config.inc) could not be found. Apply as default setting. ---"
    echo "--- All additional modules are not used. ---"
else
    . ./config.inc
fi

### If the value is incorrect, convert to normal data.
if [ ! "$SERVER_HEADER" ]; then SERVER_HEADER="hakase"; fi
if [ "$BITCHK" != 32 ] && [ "$BITCHK" != 64 ]; then BITCHK=32; fi
if [ ! "$BUILD_MTS" ]; then BUILD_MTS="-j2"; fi
if [ ! "$NGX_PREFIX" ]; then NGX_PREFIX="/usr/local/nginx"; fi
if [ ! "$NGX_SBIN_PATH" ]; then NGX_SBIN_PATH="/usr/sbin/nginx"; fi
if [ ! "$NGX_CONF" ]; then NGX_CONF="/etc/nginx/nginx.conf"; fi
if [ ! "$NGX_LIB" ]; then NGX_LIB="/var/lib/nginx"; fi
if [ ! "$NGX_LOG" ]; then NGX_LOG="/var/log/nginx"; fi
if [ ! "$NGX_PID" ]; then NGX_PID="/var/run/nginx.pid"; fi
if [ ! "$NGX_LOCK" ]; then NGX_LOCK="/var/lock/nginx.lock"; fi

### Remove Old file
rm -f ${NGX_SBIN_PATH}.old

### Multithread build
BUILD_MTS="-j$(expr $(nproc) \+ 1)"

git submodule update --init --recursive

### PCRE reconf
if [ ! -f "lib/pcre/configure" ]; then
    cd lib/pcre
    autoreconf -f -i
    cd ../..
fi

### ZLIB reconf
if [ "$BITCHK" = 64 ]; then
    if [ ! -f "lib/zlib/Makefile" ]; then
        cd lib/zlib
        ./configure
        cd ../..
    fi
else
    if [ ! -f "lib/zlib_x86/Makefile" ]; then
        git submodule add --force https://github.com/madler/zlib.git lib/zlib_x86
        cd lib/zlib_x86
        ./configure
        cd ../..
    fi
fi

### PSOL Download (PageSpeed)
if [ ! -d "lib/pagespeed" ] && [ "$PAGESPEED" = 1 ]; then
    ### Download pagespeed
    cd lib
    wget -c https://github.com/apache/incubator-pagespeed-ngx/archive/v1.13.35.2-stable.zip
    unzip v1.13.35.2-stable.zip
    rm -f v1.13.35.2-stable.zip
    cd incubator-pagespeed-ngx-1.13.35.2-stable

    ### Download psol
    curl "$(scripts/format_binary_url.sh PSOL_BINARY_URL)" | tar xz
    cd ..
    mv incubator-pagespeed-ngx-1.13.35.2-stable pagespeed
    cd ..
fi

### x86, x64 Check (Configuration)
if [ "$BITCHK" = 64 ]; then
    BUILD_BIT="-m64 "
    BUILD_OPENSSL="enable-ec_nistp_64_gcc_128 "
    BUILD_ZLIB="./lib/zlib"
    BUILD_LD="-lrt -ljemalloc -Wl,-z,relro -Wl,-z,now -fPIC"
else
    BUILD_BIT=""
    BUILD_OPENSSL=""
    BUILD_ZLIB="./lib/zlib_x86"
    BUILD_LD=""
fi

### Module check
if [ "$PAGESPEED" = 1 ]; then BUILD_MODULES="--add-module=./lib/pagespeed ${PS_NGX_EXTRA_FLAGS}"; fi
if [ "$RTMP" = 1 ]; then BUILD_MODULES="${BUILD_MODULES} --add-module=./lib/nginx-rtmp-module"; fi
if [ "$NAXSI" = 1 ]; then BUILD_MODULES="${BUILD_MODULES} --add-module=./lib/naxsi/naxsi_src"; fi
if [ "$DAV_EXT" = 1 ]; then BUILD_MODULES="${BUILD_MODULES} --add-module=./lib/nginx-dav-ext-module"; fi
if [ "$FANCYINDEX" = 1 ]; then BUILD_MODULES="${BUILD_MODULES} --add-module=./lib/ngx-fancyindex"; fi

auto/configure \
--with-cc-opt="-DTCP_FASTOPEN=23 ${BUILD_BIT}-flto -g -O3 -march=native -fstack-protector-strong -fuse-ld=gold -fuse-linker-plugin --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wno-strict-aliasing -Wp,-D_FORTIFY_SOURCE=2 -gsplit-dwarf -DNGX_HTTP_HEADERS" \
--with-ld-opt="${BUILD_LD}" \
--with-openssl-opt="enable-tls13downgrade ${BUILD_OPENSSL}enable-weak-ssl-ciphers no-ssl3-method -march=native -ljemalloc -Wl,-flto" \
--builddir=objs --prefix=${NGX_PREFIX} \
--conf-path=${NGX_CONF} \
--pid-path=${NGX_PID} \
--lock-path=${NGX_LOCK} \
--http-log-path=${NGX_LOG}/access.log \
--error-log-path=${NGX_LOG}/error.log \
--sbin-path=${NGX_SBIN_PATH} \
--http-client-body-temp-path=${NGX_LIB}/client_body_temp \
--http-proxy-temp-path=${NGX_LIB}/proxy_temp \
--http-fastcgi-temp-path=${NGX_LIB}/fastcgi_temp \
--http-scgi-temp-path=${NGX_LIB}/scgi_temp \
--http-uwsgi-temp-path=${NGX_LIB}/uwsgi_temp \
--with-pcre=./lib/pcre \
--with-pcre-jit \
--with-zlib=${BUILD_ZLIB} \
--with-openssl=./lib/openssl \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_stub_status_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_geoip_module \
--with-http_gunzip_module \
--with-http_slice_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_dav_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_image_filter_module \
--with-file-aio \
--with-threads \
--with-libatomic \
--with-mail \
--with-compat \
--with-stream \
--with-http_ssl_module \
--with-mail_ssl_module \
--with-http_v2_module \
--with-http_spdy_module \
--with-http_v2_hpack_enc \
--with-stream_ssl_module \
--with-stream_geoip_module \
--with-stream_realip_module \
--with-stream_ssl_preread_module \
--add-module=./lib/ngx_devel_kit \
--add-module=./lib/ngx_brotli \
--add-module=./lib/headers-more-nginx-module \
${BUILD_MODULES}


### OpenSSL Skip
### Do not use it for the FIRST BUILD.
#touch lib/openssl/.openssl/include/openssl/ssl.h

### SERVER HEADER CONFIG
NGX_AUTO_CONFIG_H="objs/ngx_auto_config.h";have="NGINX_SERVER";value="\"${SERVER_HEADER}\""; . auto/define

### Install
make $BUILD_MTS install

### Make directory NGX_LIB
mkdir -p ${NGX_LIB}

### Check for old files
if [ -f "${NGX_SBIN_PATH}.old" ]; then
    sleep 1
    rm ${NGX_SBIN_PATH}.old
    systemctl restart nginx
fi
