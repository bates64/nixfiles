-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font Mono")
--config.color_scheme = 'Synthwave'
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- TODO: config.window_background_gradient
config.window_background_opacity = 0.5
config.macos_window_background_blur = 40

config.front_end = "WebGpu" -- https://github.com/wez/wezterm/discussions/6273

config.ssh_domains = {
  {
    name = 'arm.pc',
    remote_address = '10.2.13.87',
    username = 'alebat01',
    remote_wezterm_path = '/home/alebat01/.nix-profile/bin/wezterm',
  },
}

return config
