{ config, lib, pkgs, ... }:
let
  myRoot = pkgs.runCommand "webroot" {} ''
    mkdir $out
    echo "<?php phpinfo(); ?>" > $out/index.php
  '';

  fpmPort = 9000;
in
{
  imports = [
    ../modules/phpfpm.nix
  ];

  networking.firewall.allowedTCPPorts = [ 80 ];
  #services.postgresql.enable = true;

  roles.phpfpm = {
    enable = true;
    port = fpmPort;
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "example" = {
        default = true;
        root = myRoot;
        locations."/" = {
            index = "index.php";
        };
        locations."~ \.php$".extraConfig = ''
          fastcgi_pass 127.0.0.1:${toString fpmPort};
          fastcgi_index index.php;
        '';
      };
    };
  };
}
