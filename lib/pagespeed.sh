#!/bin/sh

wget https://codeload.github.com/apache/incubator-pagespeed-ngx/tar.gz/latest-beta
tar xz latest_beta

cd ngx_pagespeed
curl "$(scripts/format_binary_url.sh PSOL_BINARY_URL)" | tar xz

