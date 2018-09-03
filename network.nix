{
  network.description = "example infrastructure";

  hello =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./machines/hello.nix
      ];
    };

  world =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./env.nix
        ./machines/world.nix
      ];
    };

}
