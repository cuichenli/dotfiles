{
  config,
  pkgs,
  lib,
  xdg,
  user,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nix = {
    enable = false;
  };

  users.users.${user}.shell = pkgs.fish;

  homebrew = {
    enable = true;
    greedyCasks = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "uninstall";
    global.autoUpdate = true;
    taps = [
    ];
    brews = [
      "fzf"
      "the_silver_searcher"
      "pipx"
      "diffutils"
      "docker-credential-helper"
      "docker-credential-helper-ecr"
      "gpg2"
      "pinentry"
      "pinentry-mac"
      "marp-cli"
      "kubefwd"
      "watch"
      "gnu-getopt"
      "yq"
      "jenv"
      "direnv"
      "tailspin"
    ];
    casks = [
      "onedrive"
      "doll"
      "jordanbaird-ice"
      "font-maple-mono-cn"
      "font-ubuntu-mono-nerd-font"
      "firefox"
      "zen"
      "slack"
      "iterm2"
      "orbstack"
      "yaak"
      "bluesnooze"
      "aural"
      "klogg"
      "itsycal"
      "mos"
      "alt-tab"
      "kdiff3"
      "stats"
      "raycast"
      "foobar2000"
      "pixpin"
      "squirrel-app"
      "wechat"
      "maccy"
      "visual-studio-code"
    ];
  };

  programs.fish.enable = true;

  system.stateVersion = 4;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.variables.EDITOR = "nvim";
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };
}
