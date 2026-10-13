ROOT := ../../../..
SDK ?= $(ROOT)/../agon-vdplet
PYTHON := $(ROOT)/.venv/bin/python
COMPILER ?= $(HOME)/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc
CPPFLAGS := -I$(ROOT)/rally-production/include -I$(ROOT)/rally-game/include
CFLAGS := -O2 -ffp-contract=off -fno-builtin -I$(SDK)/include
.PHONY: all test native sanitize
all: test native
.work:
	mkdir -p $@
.work/assets: assets.cpp | .work
	$(CXX) -std=c++17 -O2 $(CPPFLAGS) $< -o $@
.work/asset_meta.h: .work/assets $(wildcard $(ROOT)/rally-production/include/*.hpp) $(wildcard $(ROOT)/rally-production/*.road)
	.work/assets $(ROOT)/rally-production .work
.work/oracle: oracle.cpp $(wildcard $(ROOT)/rally-production/include/*.hpp) $(wildcard $(ROOT)/rally-game/include/*.hpp) | .work
	$(CXX) -std=c++17 -O2 -ffp-contract=off $(CPPFLAGS) $< -o $@
.work/module-A.so: module.c .work/asset_meta.h
	$(CC) $(CFLAGS) -shared -fPIC -DVDPL_VARIANT=1 $< -o $@
.work/module-B.so: module.c .work/asset_meta.h
	$(CC) $(CFLAGS) -shared -fPIC -DVDPL_VARIANT=2 $< -o $@
test: .work/oracle .work/module-A.so .work/module-B.so
	$(PYTHON) test.py
	$(PYTHON) protocol_test.py
native: .work/asset_meta.h
	$(PYTHON) $(SDK)/tools/build_module.py module.c --compiler $(COMPILER) --output .work/native-a --name rally-a --variant 1 --build-id 0x52323441
	$(PYTHON) $(SDK)/tools/build_module.py module.c --compiler $(COMPILER) --output .work/native-b --name rally-b --variant 2 --build-id 0x52323442
	$(CXX) -std=c++17 -I$(SDK)/src admission.cpp -o .work/admission
	.work/admission .work/native-a/rally-a.vdpl
	.work/admission .work/native-b/rally-b.vdpl
	$(PYTHON) inspect_native.py --compiler $(COMPILER)
sanitize: .work/asset_meta.h .work/oracle
	mkdir -p .work/sanitize
	$(CC) $(CFLAGS) -g -fsanitize=address,undefined -DVDPL_VARIANT=2 unit.c -o .work/unit-sanitize
	ASAN_OPTIONS=detect_leaks=0 .work/unit-sanitize
	$(CC) $(CFLAGS) -g -fsanitize=address,undefined -shared -fPIC -DVDPL_VARIANT=1 module.c -o .work/sanitize/module-A.so
	$(CC) $(CFLAGS) -g -fsanitize=address,undefined -shared -fPIC -DVDPL_VARIANT=2 module.c -o .work/sanitize/module-B.so
	LD_PRELOAD="$(shell $(CC) -print-file-name=libasan.so)" ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 R24_MODULE_DIR="$(CURDIR)/.work/sanitize" $(PYTHON) test.py
