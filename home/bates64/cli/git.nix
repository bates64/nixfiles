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
        fsmonitor = true;
        untrackedCache = true;
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
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = false;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      merge.conflictstyle = "zdiff3";
      commit.verbose = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      help.autocorrect = "prompt";
    };
    maintenance.enable = true;
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        hyperlinks = true;
      };
    };
  };
  home.file.".config/git/gitignore".source = ./gitignore;

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi # `gh poi` to delete local branches that have been merged
    ];
  };
}
