# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**NixOS rebuild (merlon, merlow):**
```bash
sudo nixos-rebuild switch --flake .
```

**macOS rebuild (nolrem, work-mbp):**
```bash
darwin-rebuild switch --flake .
```

**Home-manager only (headless):**
```bash
home-manager switch --flake .
```

**Remote deployment:**
```bash
nixos-rebuild switch --flake github:bates64/nixfiles#<hostname>
```

## Architecture

This is a Nix flake managing multiple machines with shared configurations.

### Naming Scheme

Hosts are named after Paper Mario shamen/mystics and they roughly reflect what the host is for.

### Hosts (`/hosts/`)

Each host's `configuration.nix` is self-contained: it imports the modules it needs from `/modules/` and configures home-manager inline. The `flake.nix` is kept slim, only wiring host entry points to `nixosSystem`/`darwinSystem` with `home-manager.*Modules.*`.

| Host | Platform | Profile | Notes |
|------|----------|---------|-------|
| merlon | NixOS x86_64 | desktop | Desktop with Nvidia GPU, Wayland (Niri), FIDO2 disk encryption |
| merlow | NixOS x86_64 | headless | Hetzner VPS, headless server |
| watt | NixOS x86_64 | headless | Homelab MacBook Pro, headless |
| nolrem | nix-darwin aarch64 | laptop | MacBook Air |
| FH91CFY4QP-2 | nix-darwin aarch64 | laptop | Work MacBook, uses `alebat01` user |

Shared darwin config lives in `hosts/darwin.nix`.

### Modules (`/modules/`)

Reusable modules organised by module system:

- **`modules/system/`** - NixOS and nix-darwin system modules (auto-upgrade, gc, nixvim, tailscale, factorio, matchbox, minecraft, focus-follows-mouse). Darwin-only modules use `lib.mkIf pkgs.stdenv.isDarwin`.
- **`modules/home/`** - Home-manager modules (shell, git, rust, cpp, ghostty, niri, hammerspoon, zed, browser, etc.)
- **`modules/home/profiles/`** - Chained profiles that compose home modules:
  - `headless.nix` - CLI tools (shell, git, rust, cpp, caches). Defines the `isMacOS` option.
  - `desktop.nix` - Imports headless + GUI apps (niri, ghostty, zed, browser, vscode)
  - `laptop.nix` - Imports desktop + hammerspoon (macOS window management)

Hosts import modules à la carte. The `isMacOS` option allows conditional logic for cross-platform configs:
```nix
if config.isMacOS then [ ] else [ pkgs.mold ]
```

### Flake Structure

The `flake.nix` defines:
- `nixosConfigurations` for Linux hosts
- `darwinConfigurations` for macOS hosts
- `homeConfigurations` for standalone home-manager

Inputs are passed to modules via `specialArgs = { inherit inputs; }`.
