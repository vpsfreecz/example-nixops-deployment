{
  hello =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./ct.nix
      ];

      #deployment.targetHost = "<IP>";
      deployment.targetEnv = "none";
    };

  world =
    { config, lib, pkgs, ... }:
    {
      imports = [
        ./ct.nix
      ];

      #deployment.targetHost = "<IP>";
      deployment.targetEnv = "none";

    };
}
