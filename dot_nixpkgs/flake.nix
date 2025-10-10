{
  description = "Personal dotfiles as a flake";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";

    # Specific nixpkgs commit for awscli2
    nixpkgs-awscli = {
      url = "github:NixOS/nixpkgs/de74240d03acfd332c99dce42fc93239dcaa9cdf";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-awscli, home-manager, nix-darwin, ... }:
    let
      pkgsLinux = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      pkgsDarwin = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      # Import the specific nixpkgs for awscli2
      pkgsAwscliLinux = import nixpkgs-awscli {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      pkgsAwscliDarwin = import nixpkgs-awscli {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    in
    {
      # Expose Home Manager modules so other flakes can import them.
      homeModules = {
        # Primary Home Manager module for these dotfiles
        default = import ./home.nix;
      };

      # Expose raw files that other flakes can use without absolute paths.
      files = {
        rime = {
          defaultCustom = ./files/rime/default.custom.yaml;
          squirrelCustom = ./files/rime/squirrel.custom.yaml;
        };
      };

      # Home Manager configurations for different systems
      homeConfigurations = {
        "wsl-cuichen" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsLinux;
          extraSpecialArgs = { pkgsAwscli = pkgsAwscliLinux; };
          modules = [
            ./home.nix
            ./machines/wsl-cuichen.nix
          ];
        };

        "wsl-cuichli" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsLinux;
          extraSpecialArgs = { pkgsAwscli = pkgsAwscliLinux; };
          modules = [
            ./home.nix
            ./machines/wsl-cuichli.nix
          ];
        };

        "debian" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsLinux;
          extraSpecialArgs = { pkgsAwscli = pkgsAwscliLinux; };
          modules = [
            ./home.nix
            ./machines/debian.nix
          ];
        };
      };

      # Darwin (macOS) configurations
      darwinConfigurations."mac-mini" = nix-darwin.lib.darwinSystem {
        specialArgs = { user = "cuichli"; pkgsAwscli = pkgsAwscliDarwin; };
        modules = [
          home-manager.darwinModules.home-manager
          ./machines/mac-mini.nix
        ];
      };
    };
}

