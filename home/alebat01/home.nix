{
  imports = [
    ./auto-upgrade.nix
    ../bates64/all.nix
  ];

  home.username = "alebat01";
  home.homeDirectory = "/home/alebat01";
  programs.git.userEmail = "alex.bates@arm.com";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
