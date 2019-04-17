# Hakase-nginx
**My nginx build files.**

example Web Server - [https://ssl.hakase.io/](https://ssl.hakase.io/)

## 아래의 필수 라이브러리를 설치해주세요.
- CentOS / Red Hat - `yum install jemalloc-devel libuuid-devel libatomic libatomic_ops-devel expat-devel unzip autoconf automake libtool gd-devel libmaxminddb-devel libxslt-devel libxml2-devel gcc-c++ curl`
- Ubuntu / Debian - `apt install libjemalloc-dev uuid-dev libatomic1 libatomic-ops-dev expat unzip autoconf automake libtool libgd-dev libmaxminddb-dev libxslt1-dev libxml2-dev g++ curl`

## 설치 방법
1. 이 명령어를 이용하여 다운로드 합니다. - `git clone https://github.com/hakasenyang/nginx-build.git --recursive`
2. 필수 라이브러리를 설치합니다. (이미 설치했다면 무시합니다.)
3. config.inc 를 수정합니다. (SERVER_HEADER, Modules, 기타.)
    - 처음 소스를 다운로드 받았다면 아래 명령어를 입력하여 먼저 복사한 뒤 편집합니다.
    - `cp config.inc.example config.inc`
4. `sudo ./auto.sh` 를 실행합니다.
5. [systemd 파일](https://www.nginx.com/resources/wiki/start/topics/examples/systemd/)을 설치합니다. (이미 설치했다면 무시합니다.)
6. 버전 및 오류를 테스트합니다. : `nginx -v; nginx -t;`
7. `systemctl restart nginx` 를 실행합니다.
8. **끝!!**

## 기능 목록
- SSL Cipher 자동 설정
    - **아래 내용은 자동으로 설정됩니다. 따라서, 필요하지 않는 한 해당 설정은 nginx.conf 내에서 설정하지 마십시오.**
    - ssl_protocols : TLSv1.2 TLSv1.3
    - ssl_ciphers : [TLS13+AESGCM+AES128|TLS13+CHACHA20]:TLS13+AESGCM+AES256:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA
    - ssl_prefer_server_ciphers : On
    - ssl_ecdh_curve : X25519:P-256:P-384
    - ssl_session_timeout : 64800 (< TLSv1.3)
    - ssl_session_timeout_tls13 : 172800 (TLSv1.3 only)
    - **ssl_dhparam** 는 사용하지 마십시오. 필요 없습니다.
    - 오래된 브라우저를 지원하려면 아래 설정을 이용하십시오. (TLS 버전)
    - ssl_protocols : TLSv1 TLSv1.1 TLSv1.2 TLSv1.3
    - ssl_ciphers : [TLS13+AESGCM+AES128|TLS13+CHACHA20]:TLS13+AESGCM+AES256:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
- TLS v1.3 (**final**)
    - OpenSSL-3.0.0-dev 사용. (**final**)
    - OpenSSL equal preference patch 사용 ([BoringSSL](https://github.com/google/boringssl) & [buik](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1))
    - 제 OpenSSL Patch 파일은 [여기](https://github.com/hakasenyang/openssl-patch)에 있습니다.
- AES-NI (AES 하드웨어 가속) 이 없는 환경에서는 CHACHA20 Cipher 가 우선으로 적용됩니다. (구 기기 안드로이드 등)
    - [CHACHA20-draft](https://github.com/JemmyLoveJenny/ngx_ossl_patches/blob/master/ossl_enable_chacha20-poly1305-draft.patch) 를 지원합니다. 제작자 : [@JemmyLoveJenny](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-427554824).
- 여러 추가모듈들.
    - headers_more_nginx_module
    - Google PageSpeed for nginx
    - 그 외 여러가지
- HPACK, SSL Dynamic TLS Records 지원. (Thanks to cloudflare!)
- SSL Strict-SNI (예: http { strict_sni on; } ) (Thanks to [@JemmyLoveJenny](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-421551872))
    - Strict SNI 는 두 개 이상의 server 설정을 필요로 합니다. (server { listen 443 ssl }).
    - 만약 두 개 이상의 server 설정이 없다면, SNI 은 활성화되지 않으며 Strict SNI 도 동작하지 않습니다.
    - 인증서는 중복으로 설정해도 상관 없습니다.
    - "strict_sni_header on" 을 사용하면 잘못 된 헤더에 대한 응답을 하지 않습니다. (strict_sni 와 같이 사용해야만 적용됩니다.)
- GeoIP2 Module - [Issues #2](https://github.com/hakasenyang/nginx-build/issues/2)
    - [여기](https://github.com/leev/ngx_http_geoip2_module)서 GeoIP2 에 대한 설정 예시를 참고하십시오.

## 차후 추가 될 기능
- apt, yum 설치. (rpm, deb, etc.)
- OCSP Stapling 사용 시 메모리 공유(shm)
- 기타.

## 더 이상 사용하지 않는 기능
- SPDY (이 버전에서는 지원되지 않음.)
- GeoIP (GeoIP2 로 변경.)
