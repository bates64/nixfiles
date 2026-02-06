{ pkgs, ... }:
{
  # Packages regularly needed for C/C++ projects
  home.packages = with pkgs; [
    clang-tools
    gdb
    lldb
    gnumake
    cmake
    ninja
  ];
}
