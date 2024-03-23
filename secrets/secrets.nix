# https://blog.sekun.net/posts/manage-secrets-in-nixos/
# https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/
# https://www.youtube.com/watch?v=G5f6GC7SnhU

/*
  # Generate a key
  mkdir -p ~/.config/sops/age

  age-keygen -o ~/.config/sops/age/keys.txt
  or
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

  age-keygen -y ~/.config/sops/age/keys.txt

  # show the real value
  sops --extract '["hello"]' --decrypt secrets/secrets.yaml
*/
{ inputs, username, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      # this will use an age key that is expected to already be in the filesystem
      # age.keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };
  };
}
