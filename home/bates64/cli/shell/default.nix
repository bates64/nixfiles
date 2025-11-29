{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -l";
      la = "${pkgs.eza}/bin/eza -la";
      tree = "${pkgs.tre-command}/bin/tre";
      cat = "${pkgs.bat}/bin/bat";
      amend = "git commit --amend --no-edit";
      fd = "${pkgs.fd}/bin/fd";
      nix = "noglob nix"; # prevent '#' expansion
    };
    initContent = ''
      eval "$(${pkgs.mcfly}/bin/mcfly init zsh)"
    '';
    plugins = with pkgs; [
      # theme
      {
        name = "powerline10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerline10k-config";
        src = ./.;
        file = "p10k.zsh";
      }

      {
        name = "formarks";
        src = fetchFromGitHub {
          owner = "wfxr";
          repo = "formarks";
          rev = "8abce138218a8e6acd3c8ad2dd52550198625944";
          sha256 = "1wr4ypv2b6a2w9qsia29mb36xf98zjzhp3bq4ix6r3cmra3xij90";
        };
        file = "formarks.plugin.zsh";
        # depends on fzf
      }
      {
        name = zsh-syntax-highlighting.pname;
        src = zsh-syntax-highlighting.src;
      }
      {
        name = "zsh-abbrev-alias";
        src = fetchFromGitHub {
          owner = "momo-lab";
          repo = "zsh-abbrev-alias";
          rev = "637f0b2dda6d392bf710190ee472a48a20766c07";
          sha256 = "16saanmwpp634yc8jfdxig0ivm1gvcgpif937gbdxf0csc6vh47k";
        };
        file = "abbrev-alias.plugin.zsh";
      }
      {
        name = zsh-autopair.pname;
        src = zsh-autopair.src;
      }
      {
        name = zsh-z.pname;
        src = zsh-z.src;
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide.enable = true;

  # lorri > nix-direnv, but lorri is not available on macOS
  programs.direnv = {
    enable = true;
    nix-direnv.enable = config.isMacOS;
  };
  services.lorri.enable = !config.isMacOS;

  home.packages = with pkgs; [
    mosh
    nixd
    codex
  ];
}
