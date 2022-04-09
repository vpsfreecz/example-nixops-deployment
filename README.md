# Using NixOPS via vpsFree.cz (a NixOS friendly hoster)

This guide tries to assemble all relevant information to enable to you to deploy your setup to vpsFree using nixops 2.0 and nix 2.7.

If your are new to NixOps and/or vpsFree we recommend reading
* nixops 2.0 [manual](https://nixops.readthedocs.io/en/latest/)
* this  deployment example [uptodate version](https://github.com/vpsfreecz/example-nixops-deployment/)

We assume that you have created a VPS from https://vpsadmin.vpsfree.cz using
its [admin interface](https://vpsadmin.vpsfree.cz)

* Start it and wait till it is finished
* Check that you can ping it via its IP address. In this example we will use for this IP `1.2.3.4`.
* Verify that you can enter ssh into this machine without a password using `ssh root@1.2.3.4`
* Ensure that you have a recent version of nix (we use 2.7, but from 2.5 upwards will probably be okay)
* Ensure that your `nixops --version` responds with something like `NixOps 2.0.0-pre-7220cbd`
* Adapt in machines/hello.nix the value of `1.2.3.4` in the targetHost definition
* Change in machines/hello.nix "your ssh key" to your public key

Now test everything with the following commands on you shell

* `git clone https://github.com/vpsfreecz/example-nixops-deployment.git`
* `cd example-nixops-deployment`
* `nixops create -d hello`
* `nixops deploy -d hello --test`
* Verify that you can enter via `ssh root@1.2.3.4` and have the commands like vim, git, fish installed
* `nixops deploy -d hello --boot --force-reboot` to activate your machine

If we do not specify the `NIXOPS_DEPLOYMENT` environment variable, we need to use the `-d` parameter and specify the name of the deployment.

## Modifications done compared to a minimum

### in `machines/hello.nix`

* Addded `imports = [ ../vpsadminos.nix ];`
* Disabled creating the manual, which takes a long time by setting `documentation.nixos.enable = false;`
* Enable OpenSSH to be able login after reboot via `services.openssh.enable = true;`

### in flake.nixops

* Added `network.enableRollback = true;` for rollback. Use it `nixops list-generations -d hello`

### in vpsadminos.nix

Here we might have problems as I think the definitions for documentation and
openssh might contradict with the settings in machine/hello.nix.

## Ensure correct versions of nix and nixops

If `nixops` commands fails with

    error: Cannot call 'builtins.getFlake' because experimental Nix feature 'flakes' is disabled. You can enable it via '--extra-experimental-features flakes'.

Then add the line `experimental-features = nix-command flakes` in your `~/.config/nix/nix.conf`.

If nixops/nix still fails, try to open a nix shell with the correct program
version using `nix develop` or `nix-develop` in your checkout. Now you should be
able to get the correct output

## Background info: Deploying using none backend

To deploy physical machines or containers, we used the none backend, which does not create any machines but uses SSH to upload the new configuration. Similar to a virtualized deployment, we create a new deployment called none by NOT setting deployment.targetEnv in machine/hello.nix.

Before the actual deployment, we need to create the target machines (VPSs) and change the IP addresses in machine/hello.nix.

The none backend will generate a new SSH key pair and ask for the password to the machine/VPS when the deploy is first run - the deploy command has therefore been supplemented with -include hello to install the first machine first. If deploy is run without the parameter, SSH will ask for the password to all machines at once.

* 2020 ? Original https://kb.vpsfree.cz/navody/vps/vpsadminos/nixops
* 30.3.2022: Translated with www.DeepL.com/Translator (free version)
* 30.3.2022: Port to markdown syntax, tested on NixOS 21.11. Has failures with NixOS 1.7
* 09.4.2022: Port to nix 2.7/nixops 2.2
