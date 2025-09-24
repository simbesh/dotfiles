# Source additional config files
sources() {
  if [[ -d "$HOME/.zsh/sources" ]]; then
    for file in "$HOME/.zsh/sources"/*.zsh; do
      # Only source files that exist and are readable (avoids errors if no .zsh files found)
      [[ -r "$file" ]] && source "$file"
    done
  fi
}

# sets up ssh keys and sops/age decryption
identities() {
  mkdir -p ~/.config/sops/age
  cp -rs /mnt/c/users/simon/.ssh ~/.config
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 >~/.config/sops/age/keys.txt
}

# Create symlinks for dotfiles in current directory to ~/.config/
linkdots() {
  cp -s .zshrc ~/.zshrc
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

  # Update flake inputs to get latest versions
  nix flake update --extra-experimental-features "nix-command flakes"

  nix profile add \
    --extra-experimental-features "nix-command flakes" \
    nixpkgs#zsh \
    nixpkgs#just \
    nixpkgs#sops \
    nixpkgs#ssh-to-age \
    nixpkgs#eza \
    nixpkgs#bat \
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
  git pull
  linkdots
  identities
  sources
  installs
}
