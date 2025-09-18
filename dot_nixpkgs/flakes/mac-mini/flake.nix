{
  description = "mac mini";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager,... }: let 
    user = "cuichli";
    in 
    {
    pkgs = import nixpkgs { system = "aarch64-darwin"; };

    darwinConfigurations."baixuedeMac-mini" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit user; };
      modules = [ 
        ../../darwin-configuration.nix  {
          users.users.cuichli.home = "/Users/cuichli";
          system.primaryUser = "cuichli";

        }
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Define the user's HM module and overrides in one assignment
          home-manager.users.cuichli = {
            imports = [ ../../home.nix ];
            home.homeDirectory = "/Users/cuichli";
            home.username = "cuichli";
            home.file."Library/Rime/default.custom.yaml".source = ../../files/rime/default.custom.yaml;
            home.file."Library/Rime/squirrel.custom.yaml".source = ../../files/rime/squirrel.custom.yaml;
          };
        }
      ];
    };
  };
}
