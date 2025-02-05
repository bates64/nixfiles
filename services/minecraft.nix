{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    whitelist = {
      # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
      bates64 = "67b56058-a7f4-4cbf-8044-2db20f7add0c";
      MiniMento = "fe368e58-a96e-4b31-b424-5caf688183ee";
      Emsingtons = "a7b1e5b7-2365-42e5-a6fa-ff8dbcc347ad";
      HappyCat77 = "c5092bf9-d2da-4dd2-9556-0494d20df3ce";
    };
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
