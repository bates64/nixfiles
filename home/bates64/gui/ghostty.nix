{ config, ... }: {
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;

    # shell integrations needed for nix develop
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "catppuccin-mocha";
      font-size = 10;
      background-opacity = if config.isMacOS then 0.4 else 1.0;
      background-blur-radius = 20;
      window-padding-x = 4;
      window-padding-y = 4;
      window-padding-balance = true;
      window-padding-color = "extend";
      window-inherit-working-directory = true;
      clipboard-trim-trailing-spaces = true;
      copy-on-select = false;
      macos-titlebar-style = "tabs";
      auto-update = "off";
    };
  };
}
