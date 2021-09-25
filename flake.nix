{
  description = "Instant high-performance GraphQL API for your PostgreSQL database!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs, utils, ... }@inputs: {

    overlay = final: prev:
      let
        pkgs = final;
      in
      {
        postgraphile = (import ./postgraphile.nix {
          inherit pkgs;
        }).nodeDependencies;
      };

  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in
    {

      defaultPackage = pkgs.postgraphile;

      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.nodePackages.node2nix
          pkgs.nixpkgs-fmt
        ];
      };
    });
}
