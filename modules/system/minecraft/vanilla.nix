{
  services.minecraft-server = {
    enable = false;
    eula = true;
    declarative = true;
    whitelist = import ./whitelist.nix;
    serverProperties = {
      difficulty = 3;
      gamemode = 0;
      max-players = 10;
      motd = "arm server";
      white-list = true;
      allow-cheats = true;
    };
  };
}
