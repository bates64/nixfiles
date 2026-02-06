{
  imports = [
    ../services/darwin/focus-follows-mouse.nix
  ];

  system.defaults.NSGlobalDomain.AppleFontSmoothing = 0; # https://tonsky.me/blog/monitors/

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    casks = [
      "hammerspoon"
    ];
    onActivation.cleanup = "zap";
  };
}
