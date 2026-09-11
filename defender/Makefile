NAME=defender
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
include $(shell agondev-config --makefile)
CXXFLAGS += -std=c++17 -Wall -Wextra -Werror -fno-exceptions -fno-rtti
$(OBJS): include/game.hpp include/assets.hpp
.PHONY: test assets
assets:
	$(abspath ../.venv/bin/python) tools/generate_assets.py
test:
	mkdir -p obj
	g++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g -Iinclude src/game.cpp tests/test_game.cpp -o obj/test_game
	./obj/test_game
