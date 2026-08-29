# comment
CC       = gcc
CFLAGS  := -O2 -Wall
PREFIX  ?= /usr/local
LDLIBS  += -lm
SRCS     = $(wildcard src/*.c)
OBJS     = $(patsubst %.c,%.o,$(SRCS))
DEPS     = $(subst .o,.d,$(OBJS))
BRANCH   = $(shell git rev-parse --abbrev-ref HEAD)
BACKUPS  = $(foreach f,$(SRCS),$(f).bak)
GUARD    = $(if $(DEBUG),-g,-DNDEBUG)
swap     = $(2)-$(1)
VPATH    = src:include
.SUFFIXES:
.SUFFIXES: .c .o
.DEFAULT_GOAL := all
.PHONY: all clean install
export PREFIX
unexport LC_ALL

define BANNER
echo "target $@ on ${BRANCH}"
echo "call $(call swap,a,b)"
endef

include config.mk
-include optional.mk

ifeq ($(CC),gcc)
CFLAGS += -std=c11
else
CFLAGS += -std=c99
endif

ifneq ($(OS),Windows_NT)
LDLIBS += -ldl
endif

ifdef DEBUG
CFLAGS += -O0
endif

all: $(OBJS) $(BACKUPS) | build
	@$(BANNER)
	+$(MAKE) -C sub all
	-rm -f stale.log

build:
	@mkdir -p $@

%.o: %.c
	$(CC) $(CFLAGS) $(GUARD) -c $< -o $@
	@echo "first=$< all=$^ newer=$? stem=$*"

install: CFLAGS += -DINSTALL
install: all
	install -m 755 app $(DESTDIR)$(PREFIX)/bin
	echo 'literal $$dollar' \
	  >> install.log

clean::
	$(RM) $(OBJS) $(DEPS)
clean::
	$(RM) -r build
