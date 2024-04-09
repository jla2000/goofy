{
  description = "Game of life implemented with wgpu";

  inputs = {
    nixpkgs.url = "github:nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
