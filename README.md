# Hakase-nginx

My nginx build files.

Please edit for this file. - https://git.hakase.io/Hakase/nginx-build/blob/master/src/core/nginx.h#L23

```c
#define NGINX_SERVER          "Hakase-nginx"
```

Features
- Auto SSL Cipher settings
    - ssl_ciphers
    - ssl_prefer_server_ciphers
    - ssl_ecdh_curve
    - DO NOT USE ssl_dhparam. not required.
- Prefers ChaCha20 suites with clients that don't have AES-NI (e.g., Android devices)	
- More library!
    - headers_more_nginx_module
    - Google PageSpeed for nginx
    - and the other.
- Hpack, SSL Dynamic TLS Records Support. (Thanks to cloudflare!)
- spdy/3.1 Support.

Upcoming Features
- TLS v1.3 (draft-18)
- Old CHACHA20-POLY1305 support.
    - maybe deprecated.
- Auto build (rpm, deb, etc.)
- ETC.
