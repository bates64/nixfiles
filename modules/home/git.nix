{ lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Alex Bates";
      user.email = lib.mkDefault "alex@bates64.com";
      aliases = {
        pu = "push";
        co = "checkout";
        cm = "commit";
        sync = "submodule update --init --recursive";
      };
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
  };
  home.file.".config/git/gitignore".source = ./gitignore;

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi # `gh poi` to delete local branches that have been merged
    ];
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = "Alex Bates";
      user.email = lib.mkDefault "alex@bates64.com";
      ui.movement.edit = true;
      ui.editor = "zeditor --wait";
      fsmonitor.backend = "watchman";
      fsmonitor.watchman.register-snapshot-trigger = true;
      revset-aliases."immutable_heads()" = "builtin_immutable_heads() | (trunk().. & ~mine())"; # make others commits immutable
    };
  };

  home.packages = [ pkgs.watchman ]; # for programs.jujutsu.settings.fsmonitor.backend
}
