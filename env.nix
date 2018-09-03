{ config, pkgs, ... }:
{
  time.timeZone = "Europe/Amsterdam";
  services.openssh.enable = true;

  services.resolved.enable = false;
  networking.nameservers = [ "172.18.2.10" "172.18.2.11" "208.67.222.222" "208.67.220.220" ];

  nix.useSandbox = false;

  environment.systemPackages = with pkgs; [
    wget
    vim
    screen
    git
  ];

  #users.extraUsers.root.openssh.authorizedKeys.keys =
  #  with import ./ssh-keys.nix; [ myUser ];
}
