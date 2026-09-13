NAME=rally
.DEFAULT_GOAL := all
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
AGONDEV_CONFIG ?= agondev-config
AGONDEV_MAKEFILE := $(shell $(AGONDEV_CONFIG) --makefile 2>/dev/null)
ifeq ($(strip $(AGONDEV_MAKEFILE)),)
$(error Install agondev and put agondev-config on PATH, or set AGONDEV_CONFIG)
endif
include $(AGONDEV_MAKEFILE)
CFLAGS += -I../rally-production/include
CXXFLAGS += -std=c++17 -Wall -Wextra -Werror -fno-exceptions -fno-rtti
$(OBJS): $(wildcard include/*.hpp ../rally-production/include/*.hpp)
