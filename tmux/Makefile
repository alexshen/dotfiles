DOTFILES := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
HOME     := $(or $(HOME),$(shell echo ~))

TMCONF_SRC  := $(DOTFILES)/.tmux.conf
TMCONF_DST  := $(HOME)/.tmux.conf
TMUXDIR_DST := $(HOME)/.tmux

# Every executable in bin/ gets symlinked into ~/.tmux/.
# The tmux- prefix is stripped so the config can reference shorter names
# (e.g. bin/tmux-vertmax-toggle.sh → ~/.tmux/vertmax-toggle.sh).
BIN_SCRIPTS := $(wildcard $(DOTFILES)/bin/*)

.PHONY: install uninstall clean reinstall

install: $(TMCONF_DST)
	mkdir -p "$(TMUXDIR_DST)"
	@for src in $(BIN_SCRIPTS); do \
		link_name=$$(basename "$$src"); \
		link_name=$${link_name#tmux-}; \
		ln -sf "$$src" "$(TMUXDIR_DST)/$$link_name"; \
		printf "  %s -> %s\n" "$(TMUXDIR_DST)/$$link_name" "$$src"; \
	done
	@echo "✓ tmux dotfiles installed"

uninstall:
	@file="$(TMCONF_DST)"; \
	printf "Removing %s...\n" "$$file"; \
	if [ -L "$$file" ]; then rm "$$file" && echo "  removed"; \
	elif [ -f "$$file" ]; then echo "  WARN: $$file — regular file, not removed"; \
	else echo "  not present"; fi
	@for src in $(BIN_SCRIPTS); do \
		link_name=$$(basename "$$src"); \
		link_name=$${link_name#tmux-}; \
		link="$(TMUXDIR_DST)/$$link_name"; \
		printf "Removing %s...\n" "$$link"; \
		if [ -L "$$link" ]; then rm "$$link" && echo "  removed"; \
		elif [ -f "$$link" ]; then echo "  WARN: $$link — regular file, not removed"; \
		else echo "  not present"; fi; \
	done

reinstall: uninstall install

# Symlink ~/.tmux.conf → dotfiles/.tmux.conf
$(TMCONF_DST): $(TMCONF_SRC)
	@if [ ! -L "$@" ] && [ -f "$@" ]; then \
		echo "WARN: $@ already exists as a regular file — move it out of the way first" >&2; \
		exit 1; \
	fi
	ln -sf "$(TMCONF_SRC)" "$@"

clean: uninstall
