{ lib, ... }: {
  programs.git = {
    enable = true;
    userName = "Alex Bates";
    userEmail = lib.mkDefault "alex@bates64.com";
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
}
