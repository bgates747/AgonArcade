NAME=rally
.DEFAULT_GOAL := all
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
ifneq ($(shell command -v agondev-config 2>/dev/null),)
include $(shell agondev-config --makefile)
else
.PHONY: all
all: remote
endif
CXXFLAGS += -std=c++17 -Wall -Wextra -Werror -fno-exceptions -fno-rtti
$(OBJS): include/road.hpp include/band_table.hpp include/track.hpp include/car.hpp include/traffic.hpp include/demo.hpp include/scenery.hpp include/scenery_data.hpp include/pacing.hpp include/workload.hpp
.PHONY: test track
.PHONY: remote
remote:
	$(abspath ../.venv/bin/python) tools/build_linux.py
track:
	$(abspath ../.venv/bin/python) tools/generate_track.py
test:
	mkdir -p obj
	g++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/test_road.cpp -o obj/test_road
	./obj/test_road
	g++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/test_pacing.cpp -o obj/test_pacing
	./obj/test_pacing
	g++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/test_bands.cpp -o obj/test_bands
	./obj/test_bands

.PHONY: scenery
scenery:
	$(abspath ../.venv/bin/python) tools/generate_scenery.py
