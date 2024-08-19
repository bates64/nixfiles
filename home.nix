# switch:
#   home-manager switch
# help:
#   https://nix-community.github.io/home-manager/options.xhtml

# TODO
# 1. flakes
# 2. add https://github.com/determinateSystems/fh
# https://github.com/Misterio77/nix-starter-configs
# tiling wm
# hold config e.g. inkscape prefs
# https://gvolpe.com/blog/nixos-binary-cache-ci/

{ config, pkgs, lib, stdenv, ... }:

let
  ares135 = import (builtins.fetchTarball https://github.com/bates64/nixpkgs/tarball/update/ares) { config = config.nixpkgs.config; };
  gfxpkgs = with pkgs; [
    libxkbcommon
    libGL
    wayland
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];
  star-rod = pkgs.callPackage ./applications/star-rod.nix {};
in
{
  # TODO: learn what flakes are and install nixos-chrome-pwa as a flake
  # https://github.com/Luis-Hebendanz/nixos-chrome-pwa?tab=readme-ov-file#install-as-a-flake
  imports = [
    "${fetchTarball "https://github.com/Luis-Hebendanz/nixos-chrome-pwa/tarball/master"}/modules/chrome-pwa/home.nix"
    #./hm/discord
  ];
  services.chrome-pwa.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bates64";
  home.homeDirectory = "/home/bates64";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # https://search.nixos.org

    # Shell
    zsh
    thefuck
    fzf
    mcfly
    zoxide
    bat
    eza
    tre-command

    # Applications
    kitty
    firefox
    google-chrome
    #bitwarden
    ares135.ares
    mupen64plus
    spotify
    aseprite
    gitkraken
    inkscape
    blender

    # Messaging
    discord
    slack
    # TODO: https://bluebubbles.app/install/
    zoom-us
  
    # Languages
    rustup
    clang
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
    jdk17

    # Debuggers
    gdb
    lldb

    # The best linker
    mold

    # Build systems
    gnumake
    ninja
    cmake

    # Development tools
    nixd
    godot_4
    fh # https://zero-to-nix.com/start/init-flake
    star-rod

    # Fonts
    monaspace

    # Utilities
    libsForQt5.kdialog # needed for tinyfiledialogs
    brightnessctl

    # MX Vertical mouse
    solaar

    # Monitors
    neofetch
    htop
    nvtop-nvidia
    
    # Infrastructure
    scaleway-cli
  ] ++ gfxpkgs;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # TODO: glob
    ".cargo/config.toml".source = home/.cargo/config.toml;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bates64/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = "1"; # needed for papermario old binutils
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${lib.makeLibraryPath gfxpkgs}";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # TODO: regular updates

  nixpkgs.config = {
    allowUnfree = true;
    #buildCores = 0; # use all cores
  };

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Alex Bates";
    userEmail = "alex@bates64.com";
    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      url = {
        "ssh://git@github/" = {
          insteadOf = "https://github/";
        };
      };
      pull = {
        rebase = true;
      };
      push = {
      };
    };
    difftastic = { enable = true; };
  };

  # Shell
  home.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    la = "eza -la";
    l = "eza";
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "thefuck"
      ];
    };
    initExtra = ''
      eval "$(mcfly init zsh)"
    '';
  };
  programs.mcfly.enable = true;
  programs.fzf.enable = true;
  programs.gh.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # ?
    nix-direnv.enable = true;
  };

  # Desktop environment
  #wayland.windowManager.hyprland.enable = true;
  
  # Editor
  programs.vscode = {
    enable = true;

    # using fhs fixes some stuff e.g. https://discourse.nixos.org/t/cant-run-c-debugger-in-vscode/33609
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [
      # needed for rust-analyzer
      rustup zlib openssl.dev pkg-config
    ]);
  };

  # OBS
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  # Discord
  #programs.discord = {
  #  enable = true;
  #  wrapDiscord = true;
  #};
}
