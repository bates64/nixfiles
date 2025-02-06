{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 10;
    serverAliveCountMax = 6;
    matchBlocks = {
      pc = {
        hostname = "10.2.13.87";
      };
      rock = {
        hostname = "10.2.10.61";
        user = "root";
      };
    };
  };
}
