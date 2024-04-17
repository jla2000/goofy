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
      libPath = with pkgs; lib.makeLibraryPath [
        libGL
        vulkan-loader
        libxkbcommon
        wayland
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
      ];
    in
    {
      packages.${system}.default = rustPlatform.buildRustPackage rec {
        pname = "prismatica";
        version = "0.1.0";
        src = self;
        cargoLock = {
          lockFile = ./Cargo.lock;
        };
        postFixup = ''
          patchelf --add-rpath ${libPath} $out/bin/prismatica
        '';
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [ rust ];
        LD_LIBRARY_PATH = libPath;
        RUST_LOG = "info";
      };
    };
}
