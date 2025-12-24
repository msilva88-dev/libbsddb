# SPDX-License-Identifier: CC0-1.0

# This file is dedicated to the public domain under CC0 1.0.
#
# To the extent possible under law, the author(s) have waived all
# copyright and related or neighboring rights to this file.
#
# You may use, copy, modify, and distribute this file without restriction.
#
# See: https://creativecommons.org/publicdomain/zero/1.0/


## Settings

# Configurations
AR ?= $(AR_CMD)
ARFLAGS ?= rcs
BUILDDIR ?= build
CARCH ?= $(CARCH_CMD)
CBUILD ?= $(CBUILD_CMD)
CHOST ?= $(CBUILD)
CTHREADS ?= $(CTHREADS_CMD)
CPPFLAGS ?= $(CPPFLAGS_CMD)
CC ?= $(CC_CMD)
CFLAGS ?= $(CFLAGS_CMD)
CVER ?= gnu17
DEBUG ?= false
DESTDIR ?=
DIRGRP ?= root
DIROWN ?= root
DIRPERM ?= 0755
DIRPGRP ?= false
ENABLE_DYNAMIC ?= false
ENABLE_HASH_STATISTICS ?= false
ENABLE_SHARED ?= true
ENABLE_STATIC ?= false
ENABLE_STATISTICS ?= false
FILEGRP ?= root
FILEOWN ?= root
FILEPERM ?= 0644
INCLUDEDIR ?= $(PREFIX)/include
INCDGRP ?= $(DIRGRP)
INCDOWN ?= $(DIROWN)
INCDPERM ?= $(DIRPERM)
INCFGRP ?= $(FILEGRP)
INCFOWN ?= $(FILEOWN)
INCFPERM ?= $(FILEPERM)
LD ?= $(LD_CMD)
LDHSTYLE ?= both
LDHSTYLE_LEG ?= gnu
LIBDIR ?= lib
LIBDGRP ?= $(DIRGRP)
LIBDOWN ?= $(DIROWN)
LIBDPERM ?= $(DIRPERM)
LIBFGRP ?= $(FILEGRP)
LIBFOWN ?= $(FILEOWN)
LIBFPERM ?= $(FILEPERM)
MANDIR ?= $(SHAREDIR)/man
MANDGRP ?= $(DIRGRP)
MANDOWN ?= $(DIROWN)
MANDPERM ?= $(DIRPERM)
MANFGRP ?= $(FILEGRP)
MANFOWN ?= $(FILEOWN)
MANFPERM ?= $(FILEPERM)
MARCH ?= $(MARCH_CMD)
PCDGRP ?= $(DIRGRP)
PCDOWN ?= $(DIROWN)
PCDPERM ?= $(DIRPERM)
PCFGRP ?= $(FILEGRP)
PCFOWN ?= $(FILEOWN)
PCFPERM ?= $(FILEPERM)
PKGCONFIGDIR ?= $(LIBDIR)/pkgconfig
PREFIX ?= usr
PFIXOWN ?= $(DIRGRP)
PFIXGRP ?= $(DIROWN)
PFIXPERM ?= $(DIRPERM)
SHAREDIR ?= $(PREFIX)/share
SHRDOWN ?= $(DIRGRP)
SHRDGRP ?= $(DIROWN)
SHRDPERM ?= $(DIRPERM)
VER ?= $(VER_MAJOR).$(VER_MINOR).$(VER_REV)
VER_MAJOR ?= 1
VER_MINOR ?= 85
VER_REV ?= 0

# Number of CPU threads for parallel compilation
CTHREADS_CMD != sh -c '\
getconf _NPROCESSORS_ONLN 2>/dev/null || printf "%d" 1 \
' 2>/dev/null

# Target architecture flags
CARCH_CMD != sh -c 'uname -m 2>/dev/null || printf "%s" "x86_64"' 2>/dev/null
COS_CMD != sh -c '\
uname -s 2>/dev/null || printf "%s" "Linux" \
' 2>/dev/null
CBUILD_CMD != sh -c '\
case "$(COS_CMD)" in \
    OpenBSD) \
        printf "%s-pc-%s" "$(CARCH)" "openbsd" \
        ;; \
    HyperbolaBSD) \
        printf "%s-pc-%s" "$(CARCH)" "hyperbolabsd" \
        ;; \
    *Linux|*) \
        _=$$(ldd --version 2>&1 | head -n 1 | cut -d"(" -f2 | cut -d")" -f1) \
        if [ "$${_}" = "GNU libc" ]; then \
            printf "%s-pc-%s" "$(CARCH)" "linux-gnu"; \
        else \
            printf "%s-pc-%s" "$(CARCH)" "linux-musl"; \
        fi \
        ;; \
esac \
' 2>/dev/null || true
MARCH_CMD != sh -c '\
uname -m 2>/dev/null | sed "s/_/-/" 2>/dev/null || printf "%s" "x86-64" \
' 2>/dev/null
MALIGNF_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%d" 16 \
        ;; \
    x86_64|*) \
        printf "%d" 32 \
        ;; \
esac \
' 2>/dev/null
MALIGNL_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%d" 8 \
        ;; \
    x86_64|*) \
        printf "%d" 16 \
        ;; \
esac \
' 2>/dev/null
MCF_PROTECT_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%s" "branch" \
        ;; \
    x86_64|*) \
        printf "%s" "full" \
        ;; \
esac \
' 2>/dev/null

# Target library flags
BUILD_LIBRARY_CMD != sh -c '\
_DYNAMIC=""; \
_STATIC=""; \
_SP=""; \
[ "$(ENABLE_DYNAMIC)" = "true" ] && _DYNAMIC="$(BUILDDIR)/libbsddb.so"; \
[ "$(ENABLE_STATIC)" = "true" ] && _STATIC="$(BUILDDIR)/libbsddb.a"; \
if [ -z "$${_DYNAMIC}" ] && [ -z "$${_STATIC}" ]; then \
    _DYNAMIC="$(BUILDDIR)/libbsddb.so"; \
fi; \
[ -n "$${_DYNAMIC}" ] && _SP=" "; \
printf "%s%s%s" "$${_DYNAMIC}" "$${_SP}" "$${_STATIC}" \
' 2>/dev/null

# Default static archiver command flags
AR_PATH_CMD != sh -c '\
command -v binutils-ar 2>/dev/null || command -v llvm-ar 2>/dev/null \
  || command -v ar 2>/dev/null || printf "%s" "ar" \
' 2>/dev/null
AR_CMD != printf "%s" "$(AR_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default C compiler command flags
CC_PATH_CMD != sh -c '\
command -v clang 2>/dev/null || command -v gcc 2>/dev/null \
  || printf "%s" "cc" \
' 2>/dev/null
CC_CMD != printf "%s" "$(CC_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default linker command flags
LD_PATH_CMD != sh -c '\
command -v mold 2>/dev/null || command -v lld 2>/dev/null \
  || command -v ld.gold 2>/dev/null || command -v ld.bfd 2>/dev/null \
  || command -v ld 2>/dev/null  || printf "%s" "ld.bfd" \
' 2>/dev/null
LD_CMD != printf "%s" "$(LD_PATH_CMD)" | sed "s|.*/||" 2>/dev/null


## Compiler

# Optional Feature Flags
OPTFLAG_DEBUG_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%s" "-D" "DEBUG" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_DEBUG1_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%s %s%s" "-D" "DEBUG" "-D" "DEBUG1" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_DEBUG4_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%s %s%s %s%s %s%s %s%s" \
          "-D" "DEBUG" "-D" "DEBUG1" "-D" "DEBUG2" \
          "-D" "DEBUG3" "-D" "DEBUG4" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_STATS_CMD != sh -c '\
case "$(ENABLE_STATISTICS)" in \
    true) \
        printf "%s%s" "-D" "STATISTICS" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_HSTATS_CMD != sh -c '\
case "$(ENABLE_HASH_STATISTICS)" in \
    true) \
        printf "%s%s" "-D" "HASH_STATISTICS" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null

# Set appropriate flags in clang v11, GCC v8 and Binutils as v2.34
# (any language)
# -march: builds exclusively for an architecture
DFT_GENFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%s=%s %s %s" "-m" "arch" "$(MARCH)" "-pipe" "-g"; \
        ;; \
    false|*) \
        printf "%s%s=%s %s" "-m" "arch" "$(MARCH)" "-pipe"; \
        ;; \
esac \
' 2>/dev/null

# Set appropriate flags in clang v11, GCC v8 and Binutils as v2.34
# -fno-plt: (GCC-only) does not support clang v11 and bellow
# -mtune: (GCC-only) optimizes for an architecture,
#   but builds for whole processor family
LD_GENFLAGS_LLVM_CMD != sh -c '\
case "$(LD)" in \
    lld) \
        printf "%s" "-flto=thin" \
        ;; \
    *) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LD_GENFLAGS_GCC_CMD != sh -c '\
case "$(LD)" in \
    ld.gold) \
        printf "%s" "" \
        ;; \
    ld.bfd|ld|*) \
        printf "%s=%s %s" "-flto" "$(CTHREADS)" "-flto-partition=max" \
        ;; \
esac \
' 2>/dev/null
DFT_GENFLAGS_LLVM := $(DFT_GENFLAGS_CMD) $(LD_GENFLAGS_LLVM_CMD)
DFT_GENFLAGS_GCC := $(DFT_GENFLAGS_CMD)
DFT_GENFLAGS_GCC += -mtune=generic
DFT_GENFLAGS_GCC += $(LD_GENFLAGS_GCC_CMD)
DFT_GENFLAGS_GCC += -fno-plt
DFT_GENFLAGS_GCC += -falign-functions=$(MALIGNF_CMD)
DFT_GENFLAGS_GCC += -falign-loops=$(MALIGNL_CMD)
DFT_GENFLAGS_GCC += -falign-jumps=$(MALIGNF_CMD)
DFT_GENFLAGS_GCC += -fno-semantic-interposition
DFT_GENFLAGS_GCC += -fstack-clash-protection

# Optimize Flags in clang v11 and GCC v8 (any language)
DFT_OPTMFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%d" "-O" 0 \
        ;; \
    false|*) \
        printf "%s%d" "-O" 2 \
        ;; \
esac \
' 2>/dev/null

# Compiler Flags in clang v11 and GCC v8 (any language)
DFT_COMPFLAGS := $(DFT_OPTMFLAGS_CMD)
DFT_COMPFLAGS += -fno-common
DFT_COMPFLAGS += -fstack-protector-strong
DFT_COMPFLAGS += -ffunction-sections
DFT_COMPFLAGS += -fdata-sections
DFT_COMPFLAGS += -fcf-protection=$(MCF_PROTECT_CMD)
#-feliminate-unused-debug-types
DFT_COMPFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s -f%s -g%s -g%s -f%s" \
        "$(DFT_COMPFLAGS)" "no-lto" "dwarf-4" "split-dwarf" \
        "no-omit-frame-pointer" \
        ;; \
    false|*) \
        printf "%s" "$(DFT_COMPFLAGS)" \
        ;; \
esac \
' 2>/dev/null

# Compiler Flags for shared library
DFT_LIBFLAGS := -fPIC

# Compiler Flags in clang v11 and GCC v8 (C family language)
DFT_CFMLFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s" "" \
        ;; \
    false|*) \
        printf "%s%s" "-f" "pch-preprocess" \
        ;; \
esac \
' 2>/dev/null

# C compiler flags
VER_CFLAGS_CMD != sh -c '\
case "$(CVER)" in \
    *) \
        printf "%s" "-fexceptions"; \
        ;; \
esac \
' 2>/dev/null
DFT_CFLAGS := -fno-exceptions

# C Preprocessor Flags in clang v11, GCC v8 and Binutils as v2.34
# (C family language)
CPPFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "-D%s=%d -D%s" "_FORTIFY_SOURCE" 2 "DEBUG"; \
        ;; \
    false|*) \
        printf "-D%s=%d -D%s" "_FORTIFY_SOURCE" 2 "NDEBUG"; \
        ;; \
esac \
' 2>/dev/null || true

# Warning Flags
DFT_WFLAGS := -Wall
DFT_WFLAGS += -Wextra
DFT_WFLAGS += -Wimplicit-fallthrough
DFT_WFLAGS += -Wpedantic

# Compiler Flags
CFLAGS_CMD != sh -c '\
case "$(CC)" in \
    clang*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_LLVM)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
    gcc*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_GCC)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
    *) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
esac \
' 2>/dev/null

## Linker Flags

# Linker Selection (Fastest available) and set appropriate flags
# in mold v1, LLVM LLD v11 and Binutils ld.bfd/ld.gold v2.34
# Use --hash-style=sysv in HyperbolaBSD (LLD uses by default)
# and --hash-style=gnu in GNU/Linux-libre (LLD doesn't support this flag)
DFT_GENLDFLAGS_CMD != sh -c '\
case "$(LD)" in \
    mold) \
        printf "%s %s,%s=%s,%s,%s,%s=%s" \
          "-fuse-ld=mold" "-Wl" "--hash-style" "$(LDHSTYLE)" \
          "--icf=safe" "--print-icf-sections" "--jobs" "$(CTHREADS)" \
        ;; \
    lld) \
        printf "%s %s,%s=%s,%s,%s" \
          "-fuse-ld=lld" "-Wl" "--hash-style" "$(LDHSTYLE)" \
          "--icf=safe" "--print-icf-sections" \
        ;; \
    ld.gold) \
        printf "%s %s,%s=%s,%s,%s,%s" \
          "-fuse-ld=gold" "-Wl" "--hash-style" "$(LDHSTYLE_LEG)" \
          "--icf=safe" "--print-icf-sections" "--threads" \
        ;; \
    ld.bfd|ld) \
        printf "%s %s,%s=%s" \
          "-fuse-ld=bfd" "-Wl" "--hash-style" "$(LDHSTYLE)" \
        ;; \
    *) \
        printf "%s,%s=%s" \
          "-Wl" "--hash-style" "$(LDHSTYLE)" \
        ;; \
esac \
' 2>/dev/null

# Linker Flags in Binutils ld.bfd/ld.gold v2.34, LLD v11 and mold v1
DFT_LDFLAGS := $(DFT_GENLDFLAGS_CMD),$(DFT_OPTMFLAGS_CMD)
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,defs
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,noexecstack
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,now
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,relro
DFT_LDFLAGS := $(DFT_LDFLAGS),--gc-sections
DFT_LDFLAGS := $(DFT_LDFLAGS),--build-id
DFT_LDFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s,%s %s %s" \
          "$(DFT_LDFLAGS)" "--no-as-needed" "-g" "-rdynamic" \
        ;; \
    false|*) \
        printf "%s,%s" "$(DFT_LDFLAGS)" "--as-needed" \
        ;; \
esac \
' 2>/dev/null

# Linker Flags for optional libraries
LNK_LDFLAGS :=

# Linker Flags for shared code
DFT_SHAREDLDFLAGS := -shared

# Linker Flags
LDFLAGS := $(DFT_LDFLAGS_CMD)

## Make macros

LIBS := $(BUILD_LIBRARY_CMD)

COMMON_OBJS :=
LIBBSDDB_OBJS := $(BUILDDIR)/btree/bt_close.o $(BUILDDIR)/btree/bt_conv.o
LIBBSDDB_OBJS += $(BUILDDIR)/btree/bt_debug.o $(BUILDDIR)/btree/bt_delete.o
LIBBSDDB_OBJS += $(BUILDDIR)/btree/bt_get.o $(BUILDDIR)/btree/bt_open.o
LIBBSDDB_OBJS += $(BUILDDIR)/btree/bt_overflow.o $(BUILDDIR)/btree/bt_page.o
LIBBSDDB_OBJS += $(BUILDDIR)/btree/bt_put.o $(BUILDDIR)/btree/bt_search.o
LIBBSDDB_OBJS += $(BUILDDIR)/btree/bt_seq.o $(BUILDDIR)/btree/bt_split.o
LIBBSDDB_OBJS += $(BUILDDIR)/btree/bt_utils.o $(BUILDDIR)/db/db.o
LIBBSDDB_OBJS += $(BUILDDIR)/hash/hash.o $(BUILDDIR)/hash/hash_bigkey.o
LIBBSDDB_OBJS += $(BUILDDIR)/hash/hash_buf.o $(BUILDDIR)/hash/hash_func.o
LIBBSDDB_OBJS += $(BUILDDIR)/hash/hash_log2.o $(BUILDDIR)/hash/hash_page.o
LIBBSDDB_OBJS += $(BUILDDIR)/hash/ndbm.o $(BUILDDIR)/mpool/mpool.o
LIBBSDDB_OBJS += $(BUILDDIR)/recno/rec_close.o $(BUILDDIR)/recno/rec_delete.o
LIBBSDDB_OBJS += $(BUILDDIR)/recno/rec_get.o $(BUILDDIR)/recno/rec_open.o
LIBBSDDB_OBJS += $(BUILDDIR)/recno/rec_put.o $(BUILDDIR)/recno/rec_search.o
LIBBSDDB_OBJS += $(BUILDDIR)/recno/rec_seq.o $(BUILDDIR)/recno/rec_utils.o

LIBBSDDB_HDRS := include/bsddb.h include/bsdndbm.h

LIBBSDDB_MANS := man/btree.3 man/dbopen.3 man/hash.3 man/ndbm.3 man/recno.3

LIBBSDDB_PCS := $(BUILDDIR)/libbsddb.pc

## build

all: $(BUILDDIR) $(BUILDDIR)/btree $(BUILDDIR)/db $(BUILDDIR)/hash \
  $(BUILDDIR)/mpool $(BUILDDIR)/recno $(LIBS) $(BUILDDIR)/libbsddb.pc

$(BUILDDIR):
	mkdir -p "$(BUILDDIR)"
$(BUILDDIR)/btree:
	mkdir -p "$(BUILDDIR)/btree"
$(BUILDDIR)/db:
	mkdir -p "$(BUILDDIR)/db"
$(BUILDDIR)/hash:
	mkdir -p "$(BUILDDIR)/hash"
$(BUILDDIR)/mpool:
	mkdir -p "$(BUILDDIR)/mpool"
$(BUILDDIR)/recno:
	mkdir -p "$(BUILDDIR)/recno"
$(BUILDDIR)/btree/bt_close.o: btree/bt_close.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_conv.o: btree/bt_conv.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_debug.o: btree/bt_debug.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG_CMD) $(OPTFLAG_STATS_CMD) \
	  $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_delete.o: btree/bt_delete.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_get.o: btree/bt_get.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_open.o: btree/bt_open.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG_CMD) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_overflow.o: btree/bt_overflow.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG_CMD) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_page.o: btree/bt_page.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_put.o: btree/bt_put.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_STATS_CMD) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_search.o: btree/bt_search.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_seq.o: btree/bt_seq.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_split.o: btree/bt_split.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_STATS_CMD) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/btree/bt_utils.o: btree/bt_utils.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/db/db.o: db/db.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/hash.o: hash/hash.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG_CMD) $(OPTFLAG_HSTATS_CMD) \
	  $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/hash_bigkey.o: hash/hash_bigkey.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG1_CMD) $(OPTFLAG_HSTATS_CMD) \
	  $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/hash_buf.o: hash/hash_buf.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG1_CMD) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/hash_func.o: hash/hash_func.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/hash_log2.o: hash/hash_log2.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/hash_page.o: hash/hash_page.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG4_CMD) $(OPTFLAG_HSTATS_CMD) \
	  $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/hash/ndbm.o: hash/ndbm.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/mpool/mpool.o: mpool/mpool.c
	"$(CC)" $(CFLAGS) $(OPTFLAG_DEBUG_CMD) $(OPTFLAG_STATS_CMD) \
	  $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_close.o: recno/rec_close.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_delete.o: recno/rec_delete.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_get.o: recno/rec_get.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_open.o: recno/rec_open.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_put.o: recno/rec_put.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_search.o: recno/rec_search.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_seq.o: recno/rec_seq.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/recno/rec_utils.o: recno/rec_utils.c
	"$(CC)" $(CFLAGS) $(DFT_LIBFLAGS) -c $? -o $@
$(BUILDDIR)/libbsddb.a: $(LIBBSDDB_OBJS) $(COMMON_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE_CMD)" = "true" ]; then \
	    "$(AR)" $(ARFLAGS) "$(BUILDDIR)/libbsddb.a" $?; \
	else \
	    "$(AR)" $(ARFLAGS) "$(BUILDDIR)/libbsddb.a" \
              $(LIBBSDDB_OBJS) $(COMMON_OBJS); \
	fi
$(BUILDDIR)/libbsddb.so: $(LIBBSDDB_OBJS) $(COMMON_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE_CMD)" = "true" ]; then \
	    "$(CC)" $(LDFLAGS) $(DFT_LIBFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o "$(BUILDDIR)/libbsddb.so" $? $(LNK_LDFLAGS); \
	else \
	    "$(CC)" $(LDFLAGS) $(DFT_LIBFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o "$(BUILDDIR)/libbsddb.so" \
              $(LIBBSDDB_OBJS) $(COMMON_OBJS) $(LNK_LDFLAGS); \
	fi
$(BUILDDIR)/libbsddb.pc: libbsddb.pc.in
	if [ "$(ENABLE_DYNAMIC)" = "true" ] \
	  || [ "$(ENABLE_STATIC)" != "true" ]; \
	then \
	    _DYNAMIC=" -lbsddb"; \
	else \
	    _DYNAMIC=""; \
	fi; \
	sed \
	  -e "s|@DYNAMIC@|$${_DYNAMIC}|g" \
	  -e "s|@LIBDIR@|/$(LIBDIR)|g" \
	  -e "s|@INCLUDEDIR@|/$(INCLUDEDIR)|g" \
	  -e "s|@VER@|$(VER)|g" \
	  $? > $@

## Install

install: install-hdr install-lib install-man install-pkgconfig

## Install headers

install-hdr: $(LIBBSDDB_HDRS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	( \
	    [ -d "$(DESTDIR)/$(INCLUDEDIR)" ] \
	    || [ "$(DESTDIR)/$(INCLUDEDIR)" = "/" ] \
	) \
	  || mkdir -pm "$(INCDPERM)" "$(DESTDIR)/$(INCLUDEDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(INCLUDEDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(INCDOWN)" ] \
	  || chown "$(INCDOWN)" "$(DESTDIR)/$(INCLUDEDIR)"; \
	[ "$$2" = "$(INCDGRP)" ] \
	  || chgrp "$(INCDGRP)" "$(DESTDIR)/$(INCLUDEDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(SHAREDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(SHAREDIR)"; \
	fi

	cp -p $(LIBBSDDB_HDRS) "$(DESTDIR)/$(INCLUDEDIR)"
	for FILE in $$(ls $(LIBBSDDB_HDRS) | xargs -n1 basename); do \
	    chmod "$(INCFPERM)" \
	      "$(DESTDIR)/$(INCLUDEDIR)/$${FILE}"; \
	    chown "$(INCFOWN):$(INCFGRP)" \
	      "$(DESTDIR)/$(INCLUDEDIR)/$${FILE}"; \
	done

## Install libraries

install-lib: $(LIBS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	([ -d "$(DESTDIR)/$(LIBDIR)" ] || [ "$(DESTDIR)/$(LIBDIR)" = "/" ]) \
	  || mkdir -pm "$(LIBDPERM)" "$(DESTDIR)/$(LIBDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(LIBDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(LIBDOWN)" ] \
	  || chown "$(LIBDOWN)" "$(DESTDIR)/$(LIBDIR)"; \
	[ "$$2" = "$(LIBDGRP)" ] \
	  || chgrp "$(LIBDGRP)" "$(DESTDIR)/$(LIBDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(LIBDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(LIBDIR)"; \
	fi

	cp -p $(LIBS) "$(DESTDIR)/$(LIBDIR)"
	for FILE in $$(ls $(LIBS) | xargs -n1 basename); do \
	    chmod "$(LIBFPERM)" \
	      "$(DESTDIR)/$(LIBDIR)/$${FILE}"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/$${FILE}"; \
	done
	if [ -f "$(DESTDIR)/$(LIBDIR)/libbsddb.so" ]; then \
	    ln -s libbsddb.so \
	      "$(DESTDIR)/$(LIBDIR)/libbsddb.so.$(VER_MAJOR)"; \
	    ln -s libbsddb.so \
	      "$(DESTDIR)/$(LIBDIR)/libbsddb.so.$(VER)"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/libbsddb.so.$(VER_MAJOR)"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/libbsddb.so.$(VER)"; \
	fi

## Install manuals

install-man: $(LIBBSDDB_MANS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	( \
	    [ -d "$(DESTDIR)/$(SHAREDIR)" ] \
	    || [ "$(DESTDIR)/$(SHAREDIR)" = "/" ] \
	) \
	  || mkdir -pm "$(SHRDPERM)" "$(DESTDIR)/$(SHAREDIR)"
	([ -d "$(DESTDIR)/$(MANDIR)" ] || [ "$(DESTDIR)/$(MANDIR)" = "/" ]) \
	  || mkdir -pm "$(MANDPERM)" "$(DESTDIR)/$(MANDIR)"
	[ -d "$(DESTDIR)/$(MANDIR)/man3" ] \
	  || mkdir -pm "$(MANDPERM)" "$(DESTDIR)/$(MANDIR)/man3"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(SHAREDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(SHRDOWN)" ] \
	  || chown "$(SHRDOWN)" "$(DESTDIR)/$(SHAREDIR)"; \
	[ "$$2" = "$(SHRDGRP)" ] \
	  || chgrp "$(SHRDGRP)" "$(DESTDIR)/$(SHAREDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(SHAREDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(SHAREDIR)"; \
	fi

	OGDIR="$(DESTDIR)/$(MANDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(MANDOWN)" ] \
	  || chown "$(MANDOWN)" "$(DESTDIR)/$(MANDIR)"; \
	[ "$$2" = "$(MANDGRP)" ] \
	  || chgrp "$(MANDGRP)" "$(DESTDIR)/$(MANDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(MANDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(MANDIR)"; \
	fi

	OGDIR="$(DESTDIR)/$(MANDIR)/man3"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(MANDOWN)" ] \
	  || chown "$(MANDOWN)" "$(DESTDIR)/$(MANDIR)/man3"; \
	[ "$$2" = "$(MANDGRP)" ] \
	  || chgrp "$(MANDGRP)" "$(DESTDIR)/$(MANDIR)/man3"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(MANDIR)/man3\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(MANDIR)/man3"; \
	fi

	cp -p $(LIBBSDDB_MANS) "$(DESTDIR)/$(MANDIR)/man3"
	for FILE in $$(ls $(LIBBSDDB_MANS) | xargs -n1 basename); do \
	    chmod "$(MANFPERM)" \
	      "$(DESTDIR)/$(MANDIR)/man3/$${FILE}"; \
	    chown "$(MANFOWN):$(MANFGRP)" \
	      "$(DESTDIR)/$(MANDIR)/man3/$${FILE}"; \
	done

# Install pkg-config files

install-pkgconfig: $(LIBBSDDB_PCS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	([ -d "$(DESTDIR)/$(PKGCONFIGDIR)" ] \
	  || [ "$(DESTDIR)/$(PKGCONFIGDIR)" = "/" ]) \
	  || mkdir -pm "$(PCDPERM)" "$(DESTDIR)/$(PKGCONFIGDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(PKGCONFIGDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PCDOWN)" ] \
	  || chown "$(PCDOWN)" "$(DESTDIR)/$(PKGCONFIGDIR)"; \
	[ "$$2" = "$(PCDGRP)" ] \
	  || chgrp "$(PCDGRP)" "$(DESTDIR)/$(PKGCONFIGDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PKGCONFIGDIR)\" 2>/dev/null"; \
	    PERMS=$$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PKGCONFIGDIR)"; \
	fi

	cp -p $(LIBBSDDB_PCS) "$(DESTDIR)/$(PKGCONFIGDIR)"
	for FILE in $$(ls $(LIBBSDDB_PCS) | xargs -n1 basename); do \
	    chmod "$(PCFPERM)" \
	      "$(DESTDIR)/$(PKGCONFIGDIR)/$${FILE}"; \
	    chown "$(PCFOWN):$(PCFGRP)" \
	      "$(DESTDIR)/$(PKGCONFIGDIR)/$${FILE}"; \
	done

## Clean

clean:
	rm -frv "$(BUILDDIR)"

.PHONY: all clean \
  install install-hdr install-lib install-man install-pkgconfig \
  $(LIBBSDDB_HDRS) $(LIBS) $(LIBBSDDB_MANS) $(LIBBSDDB_PCS)
