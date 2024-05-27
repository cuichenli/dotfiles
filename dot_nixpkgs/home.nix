{ config, pkgs, ... }:

{

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

  programs.git = {
    enable = true;
    ignores = [ ".java-version" ".vscode" ".tool-versions" ];
    extraConfig = {
      "includeIf \"gitdir:~/work/\"" = {
        path = "~/.gitconfig-work";
      };
      "includeIf \"gitdir:~/personal/\"" = {
        path = "~/.gitconfig-personal";
      };

      commit = {
        gpgsign = "true";
      };
      core = {
        editor = "nvim -f";
        pager = "delta";
      };
      interactive = {
        difffilter = "delta --color-only";
      };

      delta = {
        features = "line-numbers decorations";
        whitespace-error-style = "22 reverse";
        plus-style = "syntax #012800";
        minus-style = "syntax #340001";
        syntax-theme = "Dracula";
      };

      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
      };

      gpg = {
        program = "gpg2";
      };
      pull = {
        rebase = "false";
      };
      help = {
        autoCorrect = "prompt";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      safe = {
        directory = "/Users/cuichli/dev/vde_vmnet";
      };
      push = {
        autoSetupRemote = "true";
      };
      diff = {
        algorithm = "histogram";
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };


    };
  };

  programs.neovim = {
    enable = true;

  };

  xdg.configFile.nvim = {
    source = ./config/neovim;
    recursive = true;
  };

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zinit";
        file = "zinit.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "zinit";
          rev = "v3.13.1";
          sha256 = "fnBV0LmC/wJm0pOITJ1mhiBqsg2F8AQJWvn0p/Bgo5Q=";
        };
      }
    ];
    initExtra = ''
          export EDITOR=nvim
          export BROWSER=wslview
          if [ -e ${builtins.getEnv("HOME")}/.nix-profile/etc/profile.d/nix.sh ]; then . ${builtins.getEnv("HOME")}/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

          # Disable async prompt as it is not working with zinit at the moment
          zstyle ':omz:alpha:lib:git' async-prompt no

          autoload -Uz _zinit
          (( ''${+_comps} )) && _comps[zinit]=_zinit
          ## Oh My Zsh Setting
          ZSH_THEME="robbyrussell"

          ## Zinit Setting
          # Must Load OMZ Git library
          zi snippet OMZL::git.zsh


          # Load Git plugin from OMZ
          zi snippet OMZP::git
          zi snippet OMZP::fzf
          zi cdclear -q # <- forget completions provided up to this moment

          setopt promptsubst

          # Load Prompt
          zi snippet OMZT::robbyrussell

          zinit light zsh-users/zsh-syntax-highlighting
          zinit light zsh-users/zsh-autosuggestions
          zinit light zsh-users/zsh-completions

          # The following configurations regarding history are from https://martinheinz.dev/blog/110
          # https://zsh.sourceforge.io/Doc/Release/Options.html (16.2.4 History)
    
          setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
          setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
          setopt SHARE_HISTORY         # Share history between all sessions.
          setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
          setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
          setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
          setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
          setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
          setopt APPEND_HISTORY        # append to history file (Default)
          setopt HIST_NO_STORE         # Don't store history commands
          setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.
          export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
          HISTFILE="$HOME/.zsh_history"
          HISTSIZE=10000000
          SAVEHIST=10000000
    
          HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"
    
          # Strange issue similar to https://github.com/JanDeDobbeleer/oh-my-posh/issues/2999
          autoload -U up-line-or-beginning-search
          autoload -U down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search

          bindkey "^[[A" up-line-or-beginning-search    # Arrow up
          bindkey "^[[B" down-line-or-beginning-search  # Arrow down
          eval "$(zoxide init zsh)"


                    source ${pkgs.asdf-vm.out}/etc/profile.d/asdf-prepare.sh
                export PATH="/home/cuichli/.asdf/shims:$PATH"

      # zsh in windows terminal need those 
      # https://github.com/microsoft/terminal/issues/100#issuecomment-962896948
      ### ctrl+arrows
      bindkey "\e[1;5C" forward-word
      bindkey "\e[1;5D" backward-word
      # urxvt
      bindkey "\eOc" forward-word
      bindkey "\eOd" backward-word

      ### ctrl+delete
      bindkey "\e[3;5~" kill-word
      # urxvt
      bindkey "\e[3^" kill-word

      ### ctrl+backspace
      bindkey '^H' backward-kill-word

      ### ctrl+shift+delete
      bindkey "\e[3;6~" kill-line
      # urxvt
      bindkey "\e[3@" kill-line
    '';
  };

  programs.fzf = {
    enable = true;
  };

  home.packages = with pkgs;
    [
      pinentry
      unzip
      emscripten
      zoxide
      conan
      silver-searcher
      delta
      maven
      cmake
      pkg-config
      gnumake
      wget
      lnav
      nil
      bat
      fzf
      jq
      asdf-vm
      awscli2
      htop
      tldr
      shellcheck
      coreutils-full
      httpie
      gnupg
      nixpkgs-fmt
    ];
}
