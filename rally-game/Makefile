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
# AgonDev does not garbage-collect ordinary .text; omit the private gateway
# object from normal links so the stock-compatible image has no resident API.
ifeq ($(findstring -DRALLY_HOST_TELEMETRY,$(EXTRA_GAME_FLAGS)),)
OBJS := $(filter-out obj/emos_gateway.o,$(OBJS))
endif
CFLAGS += -I../rally-production/include
CXXFLAGS += -std=c++17 -Wall -Wextra -Werror -fno-exceptions -fno-rtti
$(OBJS): $(wildcard include/*.hpp ../rally-production/include/*.hpp)

CFLAGS += $(EXTRA_GAME_FLAGS)
PYTHON := $(abspath ../.venv/bin/python)
# Single translation unit: always rebuild to prevent release/fixture flag drift.
.PHONY: FORCE check-image
$(OBJS): FORCE
FORCE:
all: check-image
check-image: $(BINARY)
	$(PYTHON) tools/check_build.py --flags='$(EXTRA_GAME_FLAGS)'
.PHONY: test assets
test:
	@mkdir -p bin
	$(CXX_HOST) -std=c++17 -Wall -Wextra -Werror -Iinclude -I../rally-production/include tests/rules_test.cpp -o bin/rules-test
	./bin/rules-test
	$(CXX_HOST) -std=c++17 -Wall -Wextra -Werror -Iinclude -I../rally-production/include tests/traffic_test.cpp -o bin/traffic-test
	./bin/traffic-test
	$(PYTHON) tools/test_route_replay.py
	$(CXX_HOST) -std=c++17 -Wall -Wextra -Werror -Iinclude tests/records_test.cpp -o bin/records-test
	cd bin && ./records-test
	$(CXX_HOST) -std=c++17 -Wall -Wextra -Werror -Iinclude -I../rally-production/include tests/scenery_test.cpp -o bin/scenery-test
	./bin/scenery-test
CXX_HOST ?= c++
assets:
	$(PYTHON) tools/generate_font.py
	$(PYTHON) tools/generate_routes.py
	$(PYTHON) tools/generate_signs.py
