{
  hello =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./ct.nix
      ];

      #deployment.targetHost = "<IP>";
      deployment.targetEnv = "dumb";
    };

  world =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./ct.nix
      ];

      #deployment.targetHost = "<IP>";
      deployment.targetEnv = "dumb";

    };
}
