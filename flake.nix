{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
  system = "x86_64-darwin";

  myNodejs = self.packages.x86_64-darwin.nodejs16_19_0;

  overlay = (final: prev: {
    yarn = prev.yarn.override {
      nodejs = myNodejs;
    };
  });

  pkgs = import nixpkgs {
    inherit system;
    overlays = [ overlay ];
  };

  in {
    packages.x86_64-darwin.nodejs16_19_0 = pkgs.stdenv.mkDerivation {
      name = "nodejs16.19.0";
      src = pkgs.fetchurl {
        url = "https://nodejs.org/dist/v16.19.0/node-v16.19.0-darwin-x64.tar.gz";
        sha256 = "sha256-SR5aVZLsoZYdy7H64oVnQozlbOnMeXewQEHhY+DBZww=";
      };
      installPhase = ''
        echo "installing nodejs"
        mkdir -p $out
        cp -r ./ $out/
      '';
      meta = {
        platforms = pkgs.lib.platforms.darwin;
      };
    };

    devShells.x86_64-darwin.default = pkgs.mkShell {
      buildInputs = [
        self.packages.x86_64-darwin.nodejs16_19_0
        pkgs.yarn
      ];
    };
  };
}
