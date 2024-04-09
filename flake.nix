{
  description = "Game of life implemented with wgpu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system}.default = nixpkgs.legacyPackages.${system}.rustPlatform.buildRustPackage {
        pname = "goofy";
        version = "0.1.0";
        src = self;
        cargoLock = {
          lockFile = ./Cargo.lock;
        };
      };
    };
}
