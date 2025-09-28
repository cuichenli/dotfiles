{
  description = "WSL2 Ubuntu";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      rootPath = "../.."; 
    in
    {

      homeConfigurations = {
        "cuichen" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
      #      inputs.dotfiles.home.nix
            /home/cuichen/Downloads/dotfiles-master/dot_nixpkgs/home.nix
            {
              home.username = "cuichen";
              home.homeDirectory = "/home/cuichen";

              home.file = {
                "/home/cuichen/.local/share/fcitx5/rime/default.custom.yaml".source =
                  /home/cuichen/Downloads/dotfiles-master/dot_nixpkgs/files/rime/default.custom.yaml;
              };
              home.packages = with pkgs; [
                nerd-fonts.ubuntu-sans
                maple-mono.CN
                copyq
              ];
            }
          ];
        };
      };
    };
}
