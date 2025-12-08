{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 10;
        serverAliveCountMax = 6;
      };
      pc = {
        hostname = "10.2.13.87";
      };
      rock = {
        hostname = "10.2.10.29";
        user = "root";
      };
    };
  };
}
