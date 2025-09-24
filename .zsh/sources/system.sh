# Source additional config files
sources() {
  if [[ -d "$HOME/.zsh/sources" ]]; then
    for file in "$HOME/.zsh/sources"/*.zsh; do
      # Only source files that exist and are readable (avoids errors if no .zsh files found)
      [[ -r "$file" ]] && source "$file"
    done
  fi
}

# Create symlinks for dotfiles in current directory to ~/.config/
linkdots() {
  for item in *; do
    target="$HOME/.config/$item"
    # Remove existing file or symlink to avoid conflicts (even broken symlinks with -L)
    [[ -e "$target" || -L "$target" ]] && rm -rf "$target"
    # Create symbolic link using full path ($PWD) to avoid relative path issues
    ln -sf "$PWD/$item" "$target"
  done
}

# Install development tools via Nix package manager
installs() {
  # Install custom nvim configuration from personal GitHub flake
  # Requires experimental flakes feature to be enabled
  nix profile add \
    --extra-experimental-features "nix-command flakes" \
    "github:smissingham/nix?dir=flakes/apps/smissingham-nvim"

  nix profile add \
    --extra-experimental-features "nix-command flakes" \
    nixpkgs#gcc \
    nixpkgs#zoxide \
    nixpkgs#fzf \
    nixpkgs#tmux \
    nixpkgs#fd \
    nixpkgs#ripgrep \
    nixpkgs#ripgrep-all \
    nixpkgs#pandoc \
    nixpkgs#uv \
    nixpkgs#bun
}

# Reload configuration - runs all setup functions in sequence
rl() {
  linkdots
  sources
  installs
}
