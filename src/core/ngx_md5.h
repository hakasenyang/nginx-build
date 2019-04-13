
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _NGX_MD5_H_INCLUDED_
#define _NGX_MD5_H_INCLUDED_


#include <ngx_config.h>
#include <ngx_core.h>

#include <openssl/md5.h>

typedef MD5_CTX  ngx_md5_t;

#define ngx_md5_init    MD5_Init
#define ngx_md5_update  MD5_Update
#define ngx_md5_final   MD5_Final


#endif /* _NGX_MD5_H_INCLUDED_ */
