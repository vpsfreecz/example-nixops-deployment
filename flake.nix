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
      domain = "hello.vpsfree.cz";
      pkgsFor = system: import nixpkgs {
        inherit system;
      };

    in {
      
      nixopsConfigurations.default = {
        inherit nixpkgs;
        network.storage.legacy.databasefile = "~/.nixops/deployments.nixops";
        network.description = domain;
        network.enableRollback = true;
        defaults.nixpkgs.pkgs = pkgsFor "x86_64-linux";
        defaults._module.args = {
          inherit domain;
        };
        
          hello = import ./machines/hello.nix;
      };

    } // utils.lib.eachDefaultSystem (system:
      let pkgs = pkgsFor system;
      in {
        defaultPackage = pkgs.hello;

        # used by nix develop and nix shell
        devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              # to test with nix (Nix) 2.7.0 and NixOps 2.0.0-pre-7220cbd use
              nix nixopsUnstable
            ];
        };
      });
}
