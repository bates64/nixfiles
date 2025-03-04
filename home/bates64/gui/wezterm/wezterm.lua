-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font Mono")
--config.color_scheme = 'Synthwave'
config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- TODO: config.window_background_gradient
config.window_background_opacity = 0.7
config.macos_window_background_blur = 40

config.front_end = "WebGpu" -- https://github.com/wez/wezterm/discussions/6273

config.max_fps = 120

config.window_close_confirmation = 'NeverPrompt'

config.ssh_domains = {
  {
    name = 'arm.pc',
    remote_address = '10.2.13.87',
    username = 'alebat01',
    remote_wezterm_path = '/home/alebat01/.nix-profile/bin/wezterm',
    default_prog = { 'zsh' },
    assume_shell = 'Posix',
  },
}

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make Jira task numbers clickable
table.insert(config.hyperlink_rules, {
  regex = [[\bGPUCORE-(\d+)\b]],
  format = 'https://jira.arm.com/browse/GPUCORE-$1',
})

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = 'https://github.com/$1/$3',
})

-- make Gerrit Change-Ids clickable
table.insert(config.hyperlink_rules, {
  regex = [[\b(I[0-9a-f]{40})\b]],
  format = 'https://eu-gerrit-1.euhpc.arm.com/q/$1',
})

-- make TI2 links clickable
table.insert(config.hyperlink_rules, {
  regex = [[\bTI2: ([0-9]+)\b]],
  format = 'https://ti2.gpu.arm.com/tables/run/$1',
})

return config
