# Source additional config files
sources() {
  if [[ -d "$HOME/.zsh/sources" ]]; then
    for file in "$HOME/.zsh/sources"/*.zsh; do
      [[ -r "$file" ]] && source "$file"
    done
  fi
}

installs() {
  nix profile install --upgrade --extra-experimental-features "nix-command flakes" "github:smissingham/nix?dir=flakes/apps/smissingham-nvim"

  nix profile install \
    nixpkgs#gcc \
    nixpkgs#zoxide \
    nixpkgs#fzf \
    nixpkgs#tmux \
    nixpkgs#fd \
    nixpkgs#ripgrep \
    nixpkgs#ripgrep-all \
    nixpkgs#pandoc
}

# Reload configuration
rl() {
  sources
}

