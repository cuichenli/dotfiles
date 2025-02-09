{ pkgs, config, ...}:
let 
  homeDir = "${config.home.homeDirectory}";
  _plugins = [
    {
      name = "asdf";
      src = pkgs.fetchFromGitHub {
          owner = "rstacruz";
          repo = "fish-asdf";
          rev = "5869c1b1ecfba63f461abd8f98cb21faf337d004";
          sha256 = "39L6UDslgIEymFsQY8klV/aluU971twRUymzRL17+6c=";
      };
    }
  ];
  nixShellPlugin = [
    {
      name = "nix-env";
      src = pkgs.fetchFromGitHub {
        owner = "lilyball";
        repo = "nix-env.fish";
        rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
        sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
      };
    }
  ];
  finalPlugins = if pkgs.stdenv.isLinux then _plugins ++ nixShellPlugin else _plugins; 
in
{
  programs.fish = {
    enable = true;

    plugins = finalPlugins;
    
    shellInit = ''
        export PATH="${homeDir}/.asdf/shims:$PATH"
        source ${homeDir}/.asdf/plugins/java/set-java-home.fish
        eval "$(zoxide init fish)"
        fish_add_path /opt/homebrew/bin 
    '';

    shellInitLast = ''
      starship init fish | source
      set -gx GPG_TTY (tty)
    '';
  };
}
