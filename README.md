# Hakase-nginx
**My nginx build files.**

Example Web Server - [https://ssl.hakase.io/](https://ssl.hakase.io/)

## Please install dependency library.
- CentOS / Red Hat - `yum install jemalloc-devel libuuid-devel libatomic libatomic_ops-devel expat-devel unzip autoconf automake libtool gd-devel libmaxminddb-devel libxslt-devel libxml2-devel gcc-c++ curl`
- Ubuntu / Debian - `apt install libjemalloc-dev uuid-dev libatomic1 libatomic-ops-dev expat unzip autoconf automake libtool libgd-dev libmaxminddb-dev libxslt1-dev libxml2-dev g++ curl`

## How to Install?
1. Clone this repository - `git clone https://github.com/hakasenyang/nginx-build.git --recursive`
2. Install dependency library. (If you have already install it, omit it.)
3. Edit for config.inc file. (SERVER_HEADER, Modules, ETC.)
    - If you receive the source for the first time, type the following command to set it.
    - Then modify config.inc.
    - `cp config.inc.example config.inc`
4. Run `sudo ./auto.sh`
5. Install [systemd file](https://www.nginx.com/resources/wiki/start/topics/examples/systemd/) (If you have already install it, omit it.)
6. Check version and error test : `nginx -v; nginx -t;`
7. Run `systemctl restart nginx`
8. **The END!!**

## Features
- Auto SSL Cipher settings
    - **The following information is preset. Do not set it yourself unless you need it.**
    - ssl_protocols : TLSv1.2 TLSv1.3
    - ssl_ciphers : [TLS13+AESGCM+AES128|TLS13+CHACHA20]:TLS13+AESGCM+AES256:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA
    - ssl_prefer_server_ciphers : On
    - ssl_ecdh_curve : X25519:P-256:P-384:P-224:P-521
    - ssl_session_timeout : 64800 (>TLSv1.3)
    - ssl_session_timeout_tls13 : 172800 (TLSv1.3 only)
    - DO NOT USE **ssl_dhparam**. Not required.
    - Use the settings below to support older browsers. (TLS Protocol)
    - ssl_protocols : TLSv1 TLSv1.1 TLSv1.2 TLSv1.3
    - ssl_ciphers : [TLS13+AESGCM+AES128|TLS13+CHACHA20]:TLS13+AESGCM+AES256:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
- TLS v1.3 (**final**)
    - Use OpenSSL-3.0.0-dev (**final**)
    - Use OpenSSL equal preference patch ([BoringSSL](https://github.com/google/boringssl) & [buik](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1))
    - My OpenSSL patch is [here](https://github.com/hakasenyang/openssl-patch).
- Prefers ChaCha20 suites with clients that don't have AES-NI(AES hardware acceleration) (e.g., Android devices)
    - Support [CHACHA20-draft](https://github.com/JemmyLoveJenny/ngx_ossl_patches/blob/master/ossl_enable_chacha20-poly1305-draft.patch) by [@JemmyLoveJenny](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-427554824).
- More library!
    - headers_more_nginx_module
    - Google PageSpeed for nginx
    - and the other.
- Support HPACK, SSL Dynamic TLS Records. (Thanks to cloudflare!)
- SSL Strict-SNI (ex: http { strict_sni on; } ) (Thanks to [@JemmyLoveJenny](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-421551872))
    - Strict SNI requires at least two ssl server settings (server { listen 443 ssl }).
    - If you do not have two server settings, SNI will not be enabled and Strict SNI will not be enabled.
    - It does not matter what kind of certificate or duplicate.
    - Use "strict_sni_header on" if you do not want to respond to invalid headers. (only with strict_sni)
- GeoIP2 Module - [Issues #2](https://github.com/hakasenyang/nginx-build/issues/2)
    - [Check the following page](https://github.com/leev/ngx_http_geoip2_module) for GeoIP2 settings method.

## Upcoming Features
- Auto build (rpm, deb, etc.)
- Memory sharing(**shm**) for OCSP Stapling.
- ETC.

## Deprecated Features
- SPDY (Not compatible this version.)
- GeoIP (Changed to GeoIP2.)
