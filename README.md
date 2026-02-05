# alex's nix flake

## Installation

### NixOS

1. Install Nix and enable flakes
2. Switch to this flake: `nixos-rebuild switch --flake github:bates64/nixfiles`

To switch to a specific machine, e.g. merlow, use `github:bates64/nixfiles#merlow` as the flake URI.

### home-manager

1. Install Nix and enable flakes
2. Install home-manager: `nix run home-manager/master -- init --switch`
3. Restart shell
4. Switch to this flake: `nix run home-manager/master -- switch --flake github:bates64/nixfiles`

## Networking

Tailscale mesh VPN connects NixOS hosts on a private network. Authenticate once per machine:
```bash
sudo tailscale up --accept-dns
```
Then SSH between hosts should Just Work.
