{
  description = "Game of life implemented with wgpu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      rust = pkgs.rust-bin.stable."latest".default.override {
        extensions = [ "rust-src" "rust-analyzer" ];
      };
      rustPlatform = pkgs.makeRustPlatform {
        cargo = rust;
        rustc = rust;
      };
    in
    {
      packages.${system}.default = rustPlatform.buildRustPackage {
        pname = "goofy";
        version = "0.1.0";
        src = self;
        cargoLock = {
          lockFile = ./Cargo.lock;
        };
      };
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;[
          rustPlatform
        ];
      };
    };
}
