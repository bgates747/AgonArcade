PYTHON := ../.venv/bin/python
.PHONY: run test
run:
	$(PYTHON) game.py
test:
	SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy $(PYTHON) -m unittest discover -s tests -v
