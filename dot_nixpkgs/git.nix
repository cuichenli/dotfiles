{
  programs.git = {
    enable = true;
    ignores = [
      ".java-version"
      ".vscode"
      ".tool-versions"
    ];
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

}
