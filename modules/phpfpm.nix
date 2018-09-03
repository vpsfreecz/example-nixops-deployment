{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.roles.phpfpm;
in
{
  options = {
    roles = {
      phpfpm = {
        enable = mkEnableOption "Enable php-fpm role";

        port = mkOption {
          type = types.ints.positive;
          default = 9000;
          description = "Port php-fpm should listen on";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.poolConfigs.mypool = ''
      listen = 127.0.0.1:${toString cfg.port}
      user = nobody
      pm = dynamic
      pm.max_children = 5
      pm.start_servers = 2
      pm.min_spare_servers = 1
      pm.max_spare_servers = 3
      pm.max_requests = 500
    '';
  };
}
