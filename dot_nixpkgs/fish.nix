{ pkgs, config, ...}:
let 
  homeDir = "${config.home.homeDirectory}";
in
{
  programs.fish = {
    enable = true;
    plugins = [
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
    

    shellInit = ''
        export PATH="${homeDir}/.asdf/shims:$PATH"
        source ${homeDir}/.asdf/plugins/java/set-java-home.fish
        eval "$(zoxide init fish)"
        fish_add_path /opt/homebrew/bin 
    '';
      # set --universal tide_right_prompt_items status cmd_duration context jobs direnv node python rustc java php pulumi ruby go gcloud distrobox toolbox terraform aws nix_shell crystal elixir zig time
#     source /Users/cuichli/.iterm2_shell_integration.fish

    shellInitLast = ''
      starship init fish | source
    '';
  };
}
