# deploy -s .#svp
# or
# nixos-rebuild --target-host zendo@192.168.2.198 --use-remote-sudo --flake .#svp boot
{inputs}: {
  sudo = "doas -u";
  autoRollback = false;
  magicRollback = false;
  nodes = {
    "svp" = {
      hostname = "192.168.2.198";
      profiles.system = {
        user = "root";
        sshUser = "zendo";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."svp";
      };
    };
  };
}