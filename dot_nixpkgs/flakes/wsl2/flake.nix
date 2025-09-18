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
    {

      homeConfigurations = {
        "cuichli" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };

          modules = [
            ../home.nix
            {
              home.username = "cuichli";
              home.homeDirectory = "/home/cuichli";
            }
          ];
        };
      };
    };
}
