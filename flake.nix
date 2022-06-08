{
  description =
    "A flake that contains standalone versions of popular Clojure tools.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    clj-nix.url = "github:jlesquembre/clj-nix";
  };
  outputs = inputs@{ self, nixpkgs, ... }:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        cljnix = inputs.clj-nix.packages.${system};
      in {
        # What apps do we need?
        # - kondo (linter)
        # - cljfmt (formatter)
        packages = {
          cljfmtWrapped = cljnix.mkCljBin {
            name = "cljfmt-wrapped";
            main-ns = "cljfmt-wrapped.main";
            projectSrc = ./cljfmt-wrapped;
            buildCommand = "clojure -T:build uber";
          };
        };

        apps = {
          cljfmt = {
            type = "app";
            program =
              "${self.packages.${system}.cljfmtWrapped}/bin/cljfmt-wrapped";
          };
        };
      });

}
