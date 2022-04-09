{ config, lib, pkgs, ... }:

let
  myRoot = pkgs.runCommand "webroot" {} ''
    mkdir $out
    echo "Hello from NixOS" > $out/index.html
  '';
in
{
  # TODO: Adapt this IP to your needs!
  deployment.targetHost = "1.2.3.4";
  # deployment.targetEnv = ; # Only set if you deploy using a nixops plugin 
  # e.g. hetzner

  deployment.keys.my-secret.text = "shhh this is a secret";
  deployment.keys.my-secret.user = "root";
  
  # Enable SSH server!
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
      "your ssh key" #TODO: replace it
      ];
  # Do not build a manual. This is time consuming and not needed on a server
  documentation.nixos.enable = false;
  imports = [ ../vpsadminos.nix ];
  
  # just to to show that we can install our favorite tools
  environment.systemPackages = with pkgs; [
    fish
    vim
    git
    htop
  ];

  networking.firewall.allowedTCPPorts = [ 80 ];
  services.nginx = {
    enable = true;
    virtualHosts = {
      "example" = {
        default = true; # this is a default vhost
        root = myRoot;
        locations = {
          "/" = {
            extraConfig = "autoindex on;";
          };
        };
      };
    };
  };
}
