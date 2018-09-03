{ config, lib, pkgs, ... }:

let
  myRoot = pkgs.runCommand "webroot" {} ''
    mkdir $out
    echo "Hello from NixOS" > $out/index.html
  '';
in
{
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
