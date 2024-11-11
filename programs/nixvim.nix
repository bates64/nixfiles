{
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };

  # TODO
  # home-manager.users.bates64 = {
  #   home.shellAliases.vim = "nvim";
  #   home.sessionVariables.EDITOR = "nvim";
  # };
}
