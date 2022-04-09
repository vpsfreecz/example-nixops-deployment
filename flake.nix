{
  # see https://nixops.readthedocs.io/en/latest/guides/deploy-without-root.html
  description = "Flake to manage my hosts on vpsfree.cz (NonRoot)";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
#    nixops-plugged.url  = "github:lukebfox/nixops-plugged";
    utils.url   = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, utils, ... }:
    let
      domain = "dummy.vpsfree.cz";
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };

    in {
      overlay = final: prev: {
        blog = prev.callPackage ./blog {};
      };
      
      nixopsConfigurations.default = {
        inherit nixpkgs;
        network.storage.legacy.databasefile = "~/.nixops/deployments.nixops";
        network.description = domain;
        network.enableRollback = true;
        defaults.nixpkgs.pkgs = pkgsFor "x86_64-linux";
        defaults._module.args = {
          inherit domain;
        };
        
          dump = import ./machines/hello.nix;
      };

    } // utils.lib.eachDefaultSystem (system:
      let pkgs = pkgsFor system;
      in {
        defaultPackage = pkgs.blog;

        # used by nix develop
        devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              # verify using nix --version; nixops --version
              # to test with nix 2.3.16 and nixops 1.7 use
              # pkgs.nix pkgs.nixops
              # to test with nix (Nix) 2.7.0 and NixOps 2.0.0-pre-7220cbd use
              unstablePkgs.nix unstablePkgs.nixopsUnstable
            ];
        };
      });
}
