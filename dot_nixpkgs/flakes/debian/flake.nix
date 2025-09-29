{
  description = "WSL2 Ubuntu";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Use the repo root flake as an input to avoid absolute paths
    dotfiles = {
      url = "path:../..";
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
    in
    {

      homeConfigurations = {
        "cuichen" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            inputs.dotfiles.homeModules.default
            {
              home.username = "cuichen";
              home.homeDirectory = "/home/cuichen";

              home.file = {
                "/home/cuichen/.local/share/fcitx5/rime/default.custom.yaml".source =
                  inputs.dotfiles.files.rime.defaultCustom;
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
