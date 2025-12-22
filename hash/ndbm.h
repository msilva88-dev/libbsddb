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

#include "../include/bsddb.h"

#define DBM_INSERT 0
#define DBM_SUFFIX ".db"

typedef struct {
	void *dptr;
	size_t dsize;
} datum;

typedef DB DBM;

int dbm_clearerr(DBM *);
void dbm_close(DBM *);
int dbm_delete(DBM *, datum);
int dbm_error(DBM *);
datum dbm_fetch(DBM *, datum);
datum dbm_firstkey(DBM *);
datum dbm_nextkey(DBM *);
DBM *dbm_open(const char *, int, mode_t);
int dbm_store(DBM *, datum, datum, int);
int dbm_dirfno(DBM *);
int dbm_rdonly(DBM *);
