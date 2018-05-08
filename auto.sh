#!/bin/sh

### Please install library.
### jemalloc jemalloc-devel libuuid ... the other...

### Remove Old file
rm -f /usr/sbin/nginx.old

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
if [ ! -f "lib/zlib/Makefile" ]; then
    cd lib/zlib
    ./configure
    cd ../..
fi

### PSOL Download (PageSpeed)
if [ ! -d "lib/pagespeed" ]; then
    ### Download pagespeed
    cd lib
    wget -c https://github.com/apache/incubator-pagespeed-ngx/archive/v1.13.35.2-stable.zip
    unzip v1.13.35.2-stable.zip
    rm -f v1.13.35.2-stable.zip
    cd incubator-pagespeed-ngx-1.13.35.2-stable

    ### Download psol
    wget -c https://dl.google.com/dl/page-speed/psol/1.13.35.2-x64.tar.gz
    tar -xzvf 1.13.35.2-x64.tar.gz
    rm -f 1.13.35.2-x64.tar.gz
    cd ..
    mv incubator-pagespeed-ngx-1.13.35.2-stable pagespeed
    cd ..
fi

auto/configure \
--with-cc-opt='-DTCP_FASTOPEN=23 -m64 -flto -g -O3 -march=native -fstack-protector-strong -fuse-ld=gold -fuse-linker-plugin --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wno-strict-aliasing -Wp,-D_FORTIFY_SOURCE=2 -gsplit-dwarf -DNGX_HTTP_HEADERS' \
--with-ld-opt='-lrt -ljemalloc -Wl,-z,relro -Wl,-z,now -fPIC' \
--with-openssl-opt="enable-tls13downgrade enable-ec_nistp_64_gcc_128 enable-weak-ssl-ciphers no-ssl3-method -DCFLAGS='-O3 -march=native -fuse-linker-plugin -ljemalloc'" \
--builddir=objs --prefix=/usr/local/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--http-log-path=/var/log/nginx/access.log \
--error-log-path=/var/log/nginx/error.log \
--sbin-path=/usr/sbin/nginx \
--http-client-body-temp-path=/var/lib/nginx/client_body_temp \
--http-proxy-temp-path=/var/lib/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi_temp \
--http-scgi-temp-path=/var/lib/nginx/scgi_temp \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi_temp \
--with-pcre=./lib/pcre \
--with-pcre-jit \
--with-zlib=./lib/zlib \
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
--with-google_perftools_module \
--with-libatomic \
--with-mail \
--with-compat \
--with-stream \
--with-http_ssl_module \
--with-mail_ssl_module \
--with-http_v2_module \
--with-http_v2_hpack_enc \
--with-stream_ssl_module \
--with-stream_geoip_module \
--with-stream_realip_module \
--with-stream_ssl_preread_module \
--add-module=./lib/ngx_devel_kit \
--add-module=./lib/ngx_brotli \
--add-module=./lib/pagespeed ${PS_NGX_EXTRA_FLAGS} \
--add-module=./lib/ngx-fancyindex \
--add-module=./lib/naxsi/naxsi_src \
--add-module=./lib/nginx-dav-ext-module \
--add-module=./lib/headers-more-nginx-module


### Deprecated (maybe) Modules
#--add-module=./lib/nginx-rtmp-module


### OpenSSL Skip
### Do not use it for the FIRST BUILD.
#touch lib/openssl/.openssl/include/openssl/ssl.h

### Install
make $BUILD_MTS install

### Check for old files
if [ -f "/usr/sbin/nginx.old" ]; then
    sleep 1
    rm /usr/sbin/nginx.old
    systemctl restart nginx
fi
