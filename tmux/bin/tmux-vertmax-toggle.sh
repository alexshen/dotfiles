#!/usr/bin/env bash
# Toggle vertical maximize for the current tmux pane.
# Saves the window layout on first press, shrinks adjacent panes to min height,
# then restores the layout on second press.

layout=$(tmux show-options -w -v @vertmax_layout 2>/dev/null)
if [ -n "$layout" ]; then
  # restore saved layout
  tmux select-layout "$layout"
  tmux set-option -wu @vertmax_layout
else
  # save current layout
  tmux set-option -w @vertmax_layout "$(tmux display-message -p '#{window_layout}')"
  current=$(tmux display-message -p '#{pane_id}')
  tmux list-panes -F '#{pane_id}' | while read -r pane; do
    if [ "$pane" != "$current" ]; then
      tmux resize-pane -t "$pane" -y 1 2>/dev/null || true
    fi
  done
fi
