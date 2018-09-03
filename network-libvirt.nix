let
  lvirt = {
    deployment.targetEnv = "libvirtd";
    deployment.libvirtd.headless = true;
    #deployment.libvirtd.memorySize = 1024;
    #deployment.libvirtd.vcpu = 2;
  };
in
{
  hello     = lvirt;
  world     = lvirt;
}
