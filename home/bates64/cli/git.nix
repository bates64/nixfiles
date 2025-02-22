{ lib, pkgs, ... }: {
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
      core = {
        excludesfile = "~/.config/git/gitignore";
      };
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
        autoSetupRemote = true;
      };
    };
    difftastic = { enable = true; };
  };
  home.file.".config/git/gitignore".source = ./gitignore;

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi # `gh poi` to delete local branches that have been merged
    ];
  };
}
