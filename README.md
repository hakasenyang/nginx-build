# Hakase-nginx

My nginx build files.

Please edit for auto.sh file. (SERVER_HEADER, PAGESPEED)

Features
- Auto SSL Cipher settings
    - ssl_protocols
    - ssl_ciphers
    - ssl_prefer_server_ciphers
    - ssl_ecdh_curve
    - DO NOT USE ssl_dhparam. not required.
- TLS v1.3 (draft-23)
    - Use OpenSSL-1.1.1-pre3 (draft 23)
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
