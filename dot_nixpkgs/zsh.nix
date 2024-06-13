{ pkgs, config, ...}:
let 
  currentPath = builtins.toString "./.";
  homeDir = "${config.home.homeDirectory}";
  hmDir = if pkgs.stdenv.isLinux then homeDir + "/.config/home-manager" else homeDir + "/.nixpkgs";
  commonScript = builtins.readFile (builtins.toString hmDir + "/files/common-zsh.zsh");
  extraScript = if pkgs.stdenv.isLinux then builtins.readFile (builtins.toString hmDir + "/files/zsh-config-in-wsl2.zsh") else "";
in
{
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
    initExtra = commonScript + ''
          
          source ${pkgs.asdf-vm.out}/etc/profile.d/asdf-prepare.sh
          
    '' + extraScript;
  };
}