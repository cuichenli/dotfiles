{ config, pkgs, lib, xdg, ... }:
let home = builtins.getEnv "HOME";
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nix = {
    package = pkgs.nixUnstable;
    nixPath = lib.mkForce [{
      darwin-config = "${home}/.nixpkgs/darwin-configuration.nix";
    }
      "${home}/.nix-defexpr/channels"];
  };
  imports = [ <home-manager/nix-darwin> ];
   
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.cuichli = {
      home.username = "cuichli";
      # home.homeDirectory = "/Users/cuichli";
      home.stateVersion = "23.05";
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
      programs.git = {
        enable = true;
        ignores = [ ".java-version" ".vscode"];
      };

      programs.zsh = {
        enable = true;
        plugins = [
          {
            name = "antigen";
            file = "antigen.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "antigen";
              rev = "v2.2.3";
              sha256 = "OB/NgpYTlMTHaohis2J/McS+oDHvDXND9FHVNnXjFsM=";
            };
          }
        ];
        initExtraFirst = "export ZSH_THEME=robbyrussell";
        shellAliases = {
          k = "kubectl";
        };
        initExtra = ''
        export JIRA_AUTH_TYPE=bearer
              export PATH=$HOME/.krew/bin:/run/current-system/sw/bin/:/$HOME/.cargo/bin:$HOME/go/bin:Users/cuichli/.nimble/bin:$PATH
              export NVM_LAZY_LOAD=true
          export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim' 'yarn' 'npm' 'home-manager' 'k' 'kubectl' 'darwin-rebuild')
          export ATUIN_NOBIND="true"
          antigen use ohmyzsh/ohmyzsh
          antigen bundle lukechilds/zsh-nvm
          antigen bundle ohmyzsh/ohmyzsh plugins/git
          antigen bundle ohmyzsh/ohmyzsh plugins/brew
          antigen bundle ohmyzsh/ohmyzsh plugins/aws
          antigen bundle ohmyzsh/ohmyzsh plugins/kubectl
          antigen bundle ohmyzsh/ohmyzsh plugins/iterm2
          antigen bundle ohmyzsh/ohmyzsh plugins/docker
          antigen bundle zsh-users/zsh-syntax-highlighting
          antigen bundle zsh-users/zsh-autosuggestions
          antigen bundle zsh-users/zsh-completions
          antigen bundle ellie/atuin@main
          antigen bundle rupa/z
          antigen bundle mroth/evalcache
          antigen apply

          bindkey '^r' _atuin_search_widget

          export AWS_PAGER=
          export GPG_TTY=$(tty)
          export TMP_PATH=$HOME/.cargo/bin:$HOME/go/bin:$PATH
          source ${pkgs.asdf-vm.out}/etc/profile.d/asdf-prepare.sh

          _evalcache jenv init -
          _evalcache direnv hook zsh
          setopt prompt_sp
          export EDITOR=nvim
        '';
      };
    };
  };



  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "uninstall";
    taps = [
      "hazelcast/hz"
      "txn2/tap"
      "quarkusio/tap"
    ];
    brews = [
      "gpg2"
      "pinentry"
      "pinentry-mac"
      "quarkus"
      "marp-cli"
      "kubefwd"
      "watch"
      "gnu-getopt"
      "yq"
      "jenv"
      "direnv"
    ];
    casks = [
      "mos"
      "macfuse"
      "alt-tab"
      "kdiff3"
      "stats"
      "doll"
      "raycast"
      "bloomrpc"
      "snipaste"
      "docker"
      "foobar2000"
      "qqmusic"
      "squirrel"
      "wechat"
      "maccy"
      "microsoft-edge"
      "telegram"
      "android-studio"
    ];
  };
  environment.systemPackages = with pkgs;
    [
      maven
      google-cloud-sdk
      colima
      lima
      rustup
      cmake
      pkg-config
      gnumake
      pgadmin4
      patchelf
      krew
      k6
      kcat
      argocd
      fluxcd
      wget
      kustomize
      jira-cli-go
      envsubst
      kubeconform
      atuin
      lnav
      nil
      rnix-lsp
      postman
      kubectl
      kubectx
      vim
      iterm2
      slack
      bat
      vscode
      fzf
      git
      kubie
      minikube
      jetbrains.idea-ultimate
      jetbrains.clion
      jetbrains.goland
      jetbrains.pycharm-professional
      jetbrains.webstorm
      jq
      asdf-vm
      kubie
      awscli2
      htop
      k9s
      grpcurl
      tldr
      shellcheck
      coreutils-full
      httpie
      gnupg
      eksctl
      aws-iam-authenticator
      nixpkgs-fmt
      grpcui
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "cuichli" ];

      environment.variables.EDITOR = "nvim";
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };
}

