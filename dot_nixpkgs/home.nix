{ config, pkgs, lib, pkgsAwscli ? pkgs, ... }:

let
  commonPkgs = import ./common-pkgs.nix { inherit pkgs pkgsAwscli; };
  personalPkgs = import ./personal-pkgs.nix { inherit pkgs; };
  workPkgs = import ./work-pkgs.nix { inherit pkgs; };
  pkgsToInstall = if pkgs.stdenv.isLinux then personalPkgs ++ commonPkgs else workPkgs ++ commonPkgs;
in
{
  imports = [
    ./git.nix
    ./fish.nix
  ];
  home.stateVersion = "23.05";

  home.activation.mise-install = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.mise}/bin/mise prune
    ${pkgs.mise}/bin/mise install
  '';


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig = {
      tools = {
        node = "lts";
        java = "temurin-21.0.8+9.0.LTS";
        gradle = "8.14.3";
      };
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

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home.file = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
    "Library/Rime/default.custom.yaml".source = ./files/rime/default.custom.yaml;
    "Library/Rime/squirrel.custom.yaml".source = ./files/rime/squirrel.custom.yaml;
  };
}
