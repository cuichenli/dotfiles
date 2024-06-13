{ config, pkgs, ... }:

let 
  commonPkgs = import ./common-pkgs.nix { inherit pkgs; };
  personalPkgs = import ./personal-pkgs.nix { inherit pkgs; };
  workPkgs = import ./work-pkgs.nix ;
  pkgsToInstall = if pkgs.stdenv.isLinux then personalPkgs ++ commonPkgs else workPkgs;

  # zsh script
  currentPath = builtins.toString "./.";
  homeDir = "${config.home.homeDirectory}";
  hmDir = if pkgs.stdenv.isLinux then homeDir + "/.config/home-manager" else homeDir + "/.nixpkgs";
  commonScript = builtins.readFile (builtins.toString hmDir + "/files/common-zsh.zsh");
  extraScript = if pkgs.stdenv.isLinux then builtins.readFile (builtins.toString hmDir + "/files/zsh-config-in-wsl2.zsh") else "";
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

  # programs.zsh = {
  #   enable = true;
  #   plugins = [
  #     {
  #       name = "zinit";
  #       file = "zinit.zsh";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zdharma-continuum";
  #         repo = "zinit";
  #         rev = "v3.13.1";
  #         sha256 = "fnBV0LmC/wJm0pOITJ1mhiBqsg2F8AQJWvn0p/Bgo5Q=";
  #       };
  #     }
  #   ];
  #   initExtra = commonScript + ''
  #         source ${pkgs.asdf-vm.out}/etc/profile.d/asdf-prepare.sh
  #   '' + extraScript;
  # };
  

  programs.fzf = {
    enable = true;
  };

  home.packages = pkgsToInstall;
}
