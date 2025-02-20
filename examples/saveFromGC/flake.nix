{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cache-nix-action = {
      url = "github:nix-community/cache-nix-action";
      flake = false;
    };
  };
  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};

        packages = {
          hello = pkgs.hello;

          saveFromGC = import "${inputs.cache-nix-action}/saveFromGC.nix" {
            inherit pkgs inputs;
            
            derivations = [
              packages.hello
              devShells.default
            ];
            paths = [ "${packages.hello}/bin/hello" ];
          };
        };

        devShells.default = pkgs.mkShell { buildInputs = [ pkgs.gcc ]; };
      in
      {
        inherit packages devShells;
      }
    );
}
