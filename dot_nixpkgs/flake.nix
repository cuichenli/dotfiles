{
  description = "Personal dotfiles as a flake";

  inputs = {
    # Using nixos-unstable for formatter or future needs; consumers can `follows` it.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
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
  };
}

