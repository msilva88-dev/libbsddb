/* SPDX-License-Identifier: BSD-3-Clause */

/*
 * Copyright (c) 1990, 1993, 1994
 *	The Regents of the University of California.  All rights reserved.
 *
 * Modifications to support HyperbolaBSD:
 * Copyright (c) 2025 Hyperbola Project
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/* BSD db header from FreeBSD 14.3.0 source code: include/db.h */

#ifndef _LIBBSDDB_BSDDB_INT_H
#define	_LIBBSDDB_BSDDB_INT_H

#include <unistd.h> /* issetugid() */
#include "../include/bsddb.h"
#include "features.h"

#if defined(__GLIBC__) && !defined(issetugid)
#define issetugid() ((geteuid() != getuid()) || (getegid() != getgid()))
#endif

/*
 * Little endian <==> big endian 32-bit swap macros.
 *	M_32_SWAP	swap a memory location
 *	P_32_SWAP	swap a referenced memory location
 *	P_32_COPY	swap from one location to another
 */
#define	M_32_SWAP(a) {				\
	uint32_t _tmp = a;			\
	((char *)&a)[0] = ((char *)&_tmp)[3];	\
	((char *)&a)[1] = ((char *)&_tmp)[2];	\
	((char *)&a)[2] = ((char *)&_tmp)[1];	\
	((char *)&a)[3] = ((char *)&_tmp)[0];	\
}
#define	P_32_SWAP(a) {				\
	uint32_t _tmp = *(uint32_t *)a;		\
	((char *)a)[0] = ((char *)&_tmp)[3];	\
	((char *)a)[1] = ((char *)&_tmp)[2];	\
	((char *)a)[2] = ((char *)&_tmp)[1];	\
	((char *)a)[3] = ((char *)&_tmp)[0];	\
}
#define	P_32_COPY(a, b) {			\
	((char *)&(b))[0] = ((char *)&(a))[3];	\
	((char *)&(b))[1] = ((char *)&(a))[2];	\
	((char *)&(b))[2] = ((char *)&(a))[1];	\
	((char *)&(b))[3] = ((char *)&(a))[0];	\
}

/*
 * Little endian <==> big endian 16-bit swap macros.
 *	M_16_SWAP	swap a memory location
 *	P_16_COPY	swap from one location to another
 */
#define	M_16_SWAP(a) {				\
	uint16_t _tmp = a;			\
	((char *)&a)[0] = ((char *)&_tmp)[1];	\
	((char *)&a)[1] = ((char *)&_tmp)[0];	\
}
#define	P_16_COPY(a, b) {			\
	((char *)&(b))[0] = ((char *)&(a))[1];	\
	((char *)&(b))[1] = ((char *)&(a))[0];	\
}

__BEGIN_HIDDEN_DECLS
DB *__bt_open(const char *, int, int, const BTREEINFO *, int);
DB *__hash_open(const char *, int, int, const HASHINFO *, int);
DB *__rec_open(const char *, int, int, const RECNOINFO *, int);
void __dbpanic(DB *dbp);
__END_HIDDEN_DECLS

#endif
