/* SPDX-License-Identifier: CC0-1.0 */

/*
 * Public Domain
 *
 * Modifications to support HyperbolaBSD:
 * Written in 2025 by Hyperbola Project
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <https://creativecommons.org/publicdomain/zero/1.0/>.
 */

#ifndef _LIBBSDDB_FEATURES_INT_H
#define _LIBBSDDB_FEATURES_INT_H

#ifdef __GNUC__
#define __BEGIN_HIDDEN_DECLS _Pragma("GCC visibility push(hidden)")
#define __END_HIDDEN_DECLS _Pragma("GCC visibility pop")
#define DEF_WEAK(x) \
        extern __typeof(x) x __attribute__((__weak__)); \
        extern __typeof(x) __bsd4_##x __attribute__((__alias__(#x)))
        /*
         * No trailing ";" after this macro
         * to prevent Clang's [-Wextra-semi] warning.
         */
#define HIDDEN_A __attribute__((__visibility__("hidden")))
#define PROTO_NORMAL(x) HIDDEN_A extern __typeof(x) x
#else
#define __BEGIN_HIDDEN_DECLS
#define __END_HIDDEN_DECLS
#define DEF_WEAK(x)
#define HIDDEN_A
#define PROTO_NORMAL(x)
#endif

#ifndef EFTYPE
#define EFTYPE ENOTSUP
#endif

#endif
