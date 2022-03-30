Translated from https://kb.vpsfree.cz/navody/vps/vpsadminos/nixops via deepl.command


nixops
nixops manual https://nixos.org/nixops/manual/
deployment example https://github.com/vpsfreecz/example-nixops-deployment/
You can also use nixops to configure containers running on vpsFree. nixops extends the declarative configuration capabilities of NixOS to deploy a cluster of NixOS machines.

nixops can be installed between system packages using:

  environment.systemPackages = with pkgs; [
    nixops
  ];
or to a user profile using nix-env -i nixops

It is also possible to install the unstable version using nixopsUnstable.

nixops allows to use different backends and mix them. This guide also describes how to use the libvirt backend to quickly deploy to qemu using libvirtd, and the none backend to deploy pre-made VPSs over SSH.

Example

We start by cloning the repository with a sample deployment:

git clone https://github.com/vpsfreecz/example-nixops-deployment/
The deployment in network.nix defines two machines named hello and world that use include to import configuration from the machines directory. The machines/hello.nix configuration shows the deployment of the nginx webserver and the machines/world.nix configuration shows the PostgreSQL enablement.

libvirt backend
The sample deployment can be tested using the libvirt backend. Use nixops create to create a new deployment called virt, consisting of network.nix (logical configuration) and network-libvirt.nix (physical configuration, specific to libvirt).

We can deploy this deployment using the deploy command. In the case of the libvirt backend, deploy will produce the defined virtual machines and upload the new configuration to them.

If we do not specify the NIXOPS_DEPLOYMENT environment variable, we need to use the -d parameter and specify the name of the deployment.

nixops create -d virt network.nix network-libvirt.nix
nixops deploy -d virt
Now all that's left to do is find out the IP address of the hello machine using

nixops info -d virt
and test the newly uploaded webserver using curl IP.

Deployment can be changed and re-deployed using nixops deploy.

none backend
To deploy physical machines or containers, you can use none backend, which does not create any machines but uses SSH to upload the new configuration. Similar to a virtualized deployment, we create a new deployment called none that uses network-none.nix as the physical part of the configuration.

Before the actual deployment, we need to create the target machines (VPSs) and change the IP addresses in network-none.nix.

The none backend will generate a new SSH key pair and ask for the password to the machine/VPS when the deploy is first run - the deploy command has therefore been supplemented with -include hello to install the first machine first. If deploy is run without the parameter, SSH will ask for the password to all machines at once and the console will be overwhelmed - for this case it is better to use the "dumb" backend described in the next section.
nixops create -d none network.nix network-none.nix
nixops deploy -d none --include hello
dumb backend
dumb, like the none backend, works over SSH but does not create key pairs for machines. Instead, it uses the standard SSH configuration via ~/.ssh/config where the correct SSH key can be selected for use for deploy. If SSH keys are set up in vpsAdmin, this eliminates the need to reach into the target machine before deploying.

Dumb backend is available in the vpsFree fork of nixops
nixops create -d dumb network.nix network-dumb.nix
nixops deploy -d dumb
FAQ
- why do i have to repeat -d /o\
- pinning (see activation)
- different versions of nixpkgs
- ct.nix
User configurations

Translated with www.DeepL.com/Translator (free version)
