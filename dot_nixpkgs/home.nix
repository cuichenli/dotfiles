{ config, pkgs, ... }:

let 
  commonPkgs = import ./common-pkgs.nix { inherit pkgs; };
  personalPkgs = import ./personal-pkgs.nix { inherit pkgs; };
  workPkgs = import ./work-pkgs.nix { inherit pkgs; };
  pkgsToInstall = if pkgs.stdenv.isLinux then personalPkgs ++ commonPkgs else workPkgs ++ commonPkgs;
  username = if pkgs.stdenv.isLinux then builtins.getEnv ("USER") else "cuichli";
  homeDir = if pkgs.stdenv.isLinux then builtins.getEnv ("HOME") else "/root";
 in
{
  imports = [ ./git.nix ./fish.nix ];
  home.username = username;
  home.homeDirectory = homeDir;


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.neovim = {
    enable = true;
  };

  xdg.configFile.nvim = {
    source = ./config/neovim/starter;
    recursive = true;
  };

  programs.fzf = {
    enable = true;
  };

  home.packages = pkgsToInstall;
}
