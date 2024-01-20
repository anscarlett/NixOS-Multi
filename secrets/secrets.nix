# https://blog.sekun.net/posts/manage-secrets-in-nixos/
# https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/
# https://www.youtube.com/watch?v=G5f6GC7SnhU

/*
mkdir -p ~/.config/sops/age

age-keygen -o ~/.config/sops/age/keys.txt
or
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

age-keygen -y ~/.config/sops/age/keys.txt

# show the real value
sops --extract '["hello"]'  --decrypt secrets/secrets.yaml
*/
{
}
