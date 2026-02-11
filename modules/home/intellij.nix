{ pkgs, inputs, ... }:
let
  inherit (inputs.nix-jetbrains-plugins.lib) buildIdeWithPlugins;

  # https://plugins.jetbrains.com/
  plugins = [
    "com.intellij.plugins.vscodekeymap"
    "com.github.catppuccin.jetbrains"
    "com.github.catppuccin.jetbrains_icons"
    "com.github.copilot"
    "com.intellij.plugins.watcher"
    "com.intellij.uiDesigner"
  ];
in
{
  home.packages = [
    pkgs.jetbrains.jdk-no-jcef
    (buildIdeWithPlugins pkgs "idea" plugins)
  ];
}
