# INITIAL SETUP COMMANDS
---
### Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Reload tmux config
tmux source-file ~/.tmux.conf

### Inside tmux (run once):
Ctrl-a I    -> install plugins

## TMUX KEYBINDINGS
---

Prefix key: Ctrl + a

Sessions
- tmux new -s name        -> new session (from shell)
- tmux ls                -> list sessions (from shell)
- Ctrl-a d               -> detach session
- Ctrl-a $               -> rename session

Windows (Tabs)
- Ctrl-a c               -> new window
- Ctrl-a &               -> kill window
- Ctrl-a ,               -> rename window
- Ctrl-a Ctrl-h          -> previous window
- Ctrl-a Ctrl-l          -> next window
- Ctrl-a w               -> fuzzy window switch (fzf)

Panes (Splits)
- Ctrl-a |               -> split left/right
- Ctrl-a -               -> split top/bottom
- Ctrl-a h/j/k/l         -> move focus (Left/Down/Up/Right)
- Ctrl-a H/J/K/L         -> resize pane
- Ctrl-a x               -> kill pane
- Ctrl-a z               -> zoom pane
- Ctrl-a !               -> pane to new window

Navigation & Control
- Ctrl-a [               -> enter scroll/copy mode (q to exit)
- Ctrl-a p               -> fuzzy pane switch (all sessions)
- Ctrl-a Ctrl-s          -> save tmux session
- Ctrl-a Ctrl-r          -> restore tmux session
- Ctrl-a r               -> reload tmux config

## KITTY CONFIG (~/.config/kitty/kitty.conf)
---

# Split creation
map ctrl+shift+| launch --location=hsplit
map ctrl+shift+- launch --location=vsplit

# Pane navigation
map ctrl+h neighboring_window left
map ctrl+j neighboring_window down
map ctrl+k neighboring_window up
map ctrl+l neighboring_window right

# Pane resizing
map ctrl+shift+h resize_window narrower
map ctrl+shift+j resize_window taller
map ctrl+shift+k resize_window shorter
map ctrl+shift+l resize_window wider

# Zoom
map ctrl+z toggle_layout stack
