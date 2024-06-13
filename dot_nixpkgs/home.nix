{ config, pkgs, ... }:

let 
  commonPkgs = import ./common-pkgs.nix { inherit pkgs; };
  personalPkgs = import ./personal-pkgs.nix { inherit pkgs; };
  workPkgs = import ./work-pkgs.nix { inherit pkgs; };
  pkgsToInstall = if pkgs.stdenv.isLinux then personalPkgs ++ commonPkgs else workPkgs ++ commonPkgs;
 in
{
  imports = [ ./git.nix ./zsh.nix ];
  home.username = builtins.getEnv ("USER");
  home.homeDirectory = builtins.getEnv ("HOME");


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
    source = ./config/neovim;
    recursive = true;
  };

  programs.fzf = {
    enable = true;
  };

  home.packages = pkgsToInstall;
}
