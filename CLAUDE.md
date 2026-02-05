# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**NixOS rebuild (saturn, apollo):**
```bash
sudo nixos-rebuild switch --flake .
```

**macOS rebuild (mba15, work-mbp):**
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

### Hosts (`/hosts/`)

| Host | Platform | Notes |
|------|----------|-------|
| saturn | NixOS x86_64 | Desktop with Nvidia GPU, Wayland (Niri), FIDO2 disk encryption |
| apollo | NixOS x86_64 | Hetzner VPS, headless server |
| mba15 | nix-darwin aarch64 | MacBook Air |
| work-mbp | nix-darwin aarch64 | Work MacBook, uses `alebat01` user |

### Home Manager (`/home/`)

Two user profiles with layered configuration:

- **bates64/cli/** - Base configuration for all machines (shell, git, rust, cpp)
- **bates64/gui/** - Extends cli with desktop apps (browser, terminal, window manager)
- **alebat01/** - Work user, imports shared cli/gui modules

**Key pattern:** The `isMacOS` option (defined in `home/bates64/cli/default.nix`) allows conditional logic for cross-platform configs:
```nix
if config.isMacOS then [ ] else [ pkgs.mold ]
```

### System Modules

- `/tasks/` - Shared NixOS modules (auto-upgrade, garbage collection)
- `/programs/` - System-wide programs (nixvim)
- `/services/` - Server services (minecraft, factorio, mediawiki)

### Flake Structure

The `flake.nix` defines:
- `nixosConfigurations` for Linux hosts
- `darwinConfigurations` for macOS hosts
- `homeConfigurations` for standalone home-manager

Inputs are passed to modules via `extraSpecialArgs = { inherit inputs; }`.
