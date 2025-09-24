#!/usr/bin/env zsh

# Basic zsh configuration
autoload -Uz compinit
compinit

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Completion improvements
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive
zstyle ':completion:*' menu select # Arrow key navigation
zstyle ':completion:*' list-colors '' # Colorize completions

# Other useful options
setopt CORRECT # Command correction
setopt GLOB_COMPLETE # Tab completion for globs

# Source additional config files
sources

# Initialize zoxide
eval "$(zoxide init zsh)"

# Set zsh as default shell
chsh -s $(which zsh)
