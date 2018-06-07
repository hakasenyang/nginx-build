# Hakase-nginx
**My nginx build files.**

## Please install dependency library.
- CentOS / Red Hat : yum install jemalloc-devel libuuid-devel libatomic libatomic_ops-devel expat-devel unzip autoconf automake libtool gd-devel geoip-devel gcc-c++ curl
- Ubuntu / Debian - apt install libjemalloc-dev uuid-dev libatomic1 libatomic-ops-dev expat unzip autoconf automake libtool libgd-dev libgeoip-dev g++ curl

## How to Install?
1. Install dependency library. (If you have already install it, omit it.)
2. Edit for config.inc file. (SERVER_HEADER, Modules, ETC.)
    - If you receive the source for the first time, type the following command to set it.
    - Then modify config.inc.
    - cp config.inc.example config.inc
3. Run ./auto.sh
4. Install [systemd file](https://www.nginx.com/resources/wiki/start/topics/examples/systemd/) (If you have already install it, omit it.)
5. Check version and error test : **nginx -v; nginx -t;**
5. systemctl restart nginx
6. **The END!!**

## Features
- Auto SSL Cipher settings
    - **The following information is preset. Do not set it yourself unless you need it.**
    - ssl_protocols : TLSv1 TLSv1.1 TLSv1.2 TLSv1.3
    - ssl_ciphers : [TLS13+AESGCM+AES128|TLS13+AESGCM+AES256|TLS13+CHACHA20]:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
    - ssl_prefer_server_ciphers : On
    - ssl_ecdh_curve : X25519:P-256:P-384:P-224:P-521
    - DO NOT USE **ssl_dhparam**. Not required.
- TLS v1.3 (draft 23, 28)
    - Use OpenSSL-1.1.1-pre8-dev (**draft 23, 28**)
    - Use OpenSSL equal preference patch ([BoringSSL](https://github.com/google/boringssl) & [CentminMod](https://centminmod.com/))
    - My equal preference patch is [here](https://git.hakase.app/Hakase/openssl-patch/src/branch/master/openssl-equal-pre8_ciphers.patch)
- Prefers ChaCha20 suites with clients that don't have AES-NI(AES hardware acceleration) (e.g., Android devices)
- More library!
    - headers_more_nginx_module
    - Google PageSpeed for nginx
    - and the other.
- SPDY, HPACK, SSL Dynamic TLS Records Support. (Thanks to cloudflare!)

## Upcoming Features
- Support TLS v1.3 (not draft)
- Auto build (rpm, deb, etc.)
- ETC.
