NAME=rally
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
include $(shell agondev-config --makefile)
CXXFLAGS += -std=c++17 -Wall -Wextra -Werror -fno-exceptions -fno-rtti
$(OBJS): include/road.hpp include/track.hpp include/car.hpp include/traffic.hpp include/demo.hpp include/scenery.hpp include/scenery_data.hpp
.PHONY: test track
track:
	$(abspath ../.venv/bin/python) tools/generate_track.py
test:
	mkdir -p obj
	g++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude tests/test_road.cpp -o obj/test_road
	./obj/test_road

.PHONY: scenery
scenery:
	$(abspath ../.venv/bin/python) tools/generate_scenery.py
