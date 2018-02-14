#!/bin/sh
#--with-cc-opt='-m64 -march=native -DTCP_FASTOPEN=23 -g -fstack-protector-strong -flto -fuse-ld=gold --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -gsplit-dwarf' \
#--with-openssl-opt="enable-weak-ssl-ciphers enable-tls1_3 -DCFLAGS='-march=native -O3 -flto -fuse-linker-plugin'" \
#--with-openssl-opt="enable-weak-ssl-ciphers enable-tls1_3 -DCFLAGS='-march=native -O3 -flto -fuse-linker-plugin'" \


### PSOL Download (PageSpeed)
if [ ! -d "lib/ngx_pagespeed/psol" ]; then
    cd lib/ngx_pagespeed
    curl "$(scripts/format_binary_url.sh PSOL_BINARY_URL)" | tar xz
    cd ../../
fi

auto/configure \
--with-cc-opt='-DTCP_FASTOPEN=23 -m64 -g -O3 -march=native -flto -fstack-protector-strong -fuse-ld=gold -fuse-linker-plugin --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wno-strict-aliasing -Wp,-D_FORTIFY_SOURCE=2 -gsplit-dwarf --param=ssp-buffer-size=4 -DNGX_HTTP_HEADERS' \
--with-ld-opt='-ljemalloc -Wl,-z,relro' \
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
--with-pcre=./lib/pcre-8.41 \
--with-pcre-jit \
--with-zlib=./lib/zlib-1.2.11 \
--with-openssl=./lib/openssl \
--with-openssl-opt="enable-weak-ssl-ciphers -DCFLAGS='-march=native -O3 -flto -fuse-linker-plugin'" \
--with-select_module \
--with-http_v2_hpack_enc \
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
--with-http_spdy_module \
--with-stream_ssl_module \
--with-stream_geoip_module \
--with-stream_realip_module \
--with-stream_ssl_preread_module \
--add-module=./lib/ngx_devel_kit \
--add-module=./lib/ngx_brotli \
--add-module=./lib/ngx_pagespeed ${PS_NGX_EXTRA_FLAGS} \
--add-module=./lib/ngx-fancyindex \
--add-module=./lib/nginx-ct \
--add-module=./lib/nginx-dav-ext-module \
--add-module=./lib/_s/headers-more-nginx-module \
--add-module=./lib/_s/ngx_cache_purge \
--add-module=./lib/_s/set-misc-nginx-module \
--add-module=./lib/naxsi/naxsi_src

# --add-module=./lib/nginx-rtmp-module \
#cd lib/boringssl

#cmake ./
#make -j8

#cd ../../

#touch lib/openssl-1.1.0g/.openssl/include/openssl/ssl.h
#touch lib/boringssl/.openssl/include/openssl/ssl.h
make -j8 install

sleep 1

rm /usr/sbin/nginx.old
systemctl restart nginx

