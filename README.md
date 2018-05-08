# Hakase-nginx

My nginx build files.

Please edit for this file. - https://git.hakase.app/Hakase/nginx-build/src/branch/master/src/core/nginx.h#L23

```c
#define NGINX_SERVER          "hakase"
```

Features
- Auto SSL Cipher settings
    - ssl_ciphers
    - ssl_prefer_server_ciphers
    - ssl_ecdh_curve
    - DO NOT USE ssl_dhparam. not required.
- TLS v1.3 (draft-23)
    - Use OpenSSL-1.1.1-pre2
- Prefers ChaCha20 suites with clients that don't have AES-NI (e.g., Android devices)	
- More library!
    - headers_more_nginx_module
    - Google PageSpeed for nginx
    - and the other.
- Hpack, SSL Dynamic TLS Records Support. (Thanks to cloudflare!)

Upcoming Features
- Support TLS v1.3 (not draft)
- Auto build (rpm, deb, etc.)
- ETC.
