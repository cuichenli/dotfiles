{ pkgs, pkgsAwscli ? pkgs, ... }:

with pkgs;
[
  starship
  zoxide
  silver-searcher
  delta
  maven
  wget
  lnav
  nil
  bat
  fzf
  jq
  pkgsAwscli.awscli2
  htop
  tldr
  shellcheck
  coreutils-full
  httpie
  gnupg
  nixpkgs-fmt
  atuin
  carapace
  nixfmt
]
