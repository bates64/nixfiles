PaperWM = hs.loadSpoon("PaperWM")

-- Match niri layout settings
PaperWM.window_gap = 16
PaperWM.window_ratios = { 1 / 3, 1 / 2, 2 / 3 }

PaperWM.swipe_fingers = 3
PaperWM.lift_window = { "alt", "cmd", "shift" }

-- Niri-like keybindings
-- Niri uses Mod (Super) as the primary modifier. On macOS, cmd is taken by
-- system shortcuts so we use alt as the equivalent of niri's Mod.
--
-- Niri                          PaperWM
-- Mod+H/J/K/L          ->      alt+H/J/K/L        focus
-- Mod+Ctrl+H/J/K/L     ->      alt+ctrl+H/J/K/L   move/swap
-- Mod+R                 ->      alt+R               cycle width
-- Mod+Shift+R           ->      alt+shift+R         cycle height
-- Mod+F                 ->      alt+F               full width
-- Mod+C                 ->      alt+C               center
-- Mod+V                 ->      alt+V               toggle floating
-- Mod+[ / Mod+]         ->      alt+[ / alt+]       slurp/barf (consume/expel)
-- Mod+- / Mod+=         ->      alt+- / alt+=       decrease/increase width
-- Mod+1-9               ->      alt+1-9             switch space
-- Mod+Ctrl+1-9          ->      alt+ctrl+1-9        move window to space

PaperWM:bindHotkeys({
    -- Focus (niri: Mod+H/J/K/L and Mod+Arrows)
    focus_left           = { { "alt" }, "h" },
    focus_down           = { { "alt" }, "j" },
    focus_up             = { { "alt" }, "k" },
    focus_right          = { { "alt" }, "l" },

    -- Swap/move (niri: Mod+Ctrl+H/J/K/L and Mod+Ctrl+Arrows)
    swap_left            = { { "alt", "ctrl" }, "h" },
    swap_down            = { { "alt", "ctrl" }, "j" },
    swap_up              = { { "alt", "ctrl" }, "k" },
    swap_right           = { { "alt", "ctrl" }, "l" },

    -- Width cycling (niri: Mod+R / Ctrl+Mod+R)
    cycle_width          = { { "alt" }, "r" },
    reverse_cycle_width  = { { "alt", "ctrl" }, "r" },

    -- Height cycling (niri: Mod+Shift+R / Ctrl+Mod+Shift+R)
    cycle_height         = { { "alt", "shift" }, "r" },
    reverse_cycle_height = { { "alt", "ctrl", "shift" }, "r" },

    -- Width adjustments (niri: Mod+Minus / Mod+Equal)
    decrease_width       = { { "alt" }, "-" },
    increase_width       = { { "alt" }, "=" },

    -- Full width (niri: Mod+F)
    full_width           = { { "alt" }, "f" },

    -- Center (niri: Mod+C)
    center_window        = { { "alt" }, "c" },

    -- Toggle floating (niri: Mod+V)
    toggle_floating      = { { "alt" }, "v" },

    -- Slurp/barf (niri: Mod+[ consume, Mod+] expel)
    slurp_in             = { { "alt" }, "[" },
    barf_out             = { { "alt" }, "]" },

    -- Switch space (niri: Mod+1-9)
    switch_space_1       = { { "alt" }, "1" },
    switch_space_2       = { { "alt" }, "2" },
    switch_space_3       = { { "alt" }, "3" },
    switch_space_4       = { { "alt" }, "4" },
    switch_space_5       = { { "alt" }, "5" },
    switch_space_6       = { { "alt" }, "6" },
    switch_space_7       = { { "alt" }, "7" },
    switch_space_8       = { { "alt" }, "8" },
    switch_space_9       = { { "alt" }, "9" },

    -- Move window to space (niri: Mod+Ctrl+1-9)
    move_window_1        = { { "alt", "ctrl" }, "1" },
    move_window_2        = { { "alt", "ctrl" }, "2" },
    move_window_3        = { { "alt", "ctrl" }, "3" },
    move_window_4        = { { "alt", "ctrl" }, "4" },
    move_window_5        = { { "alt", "ctrl" }, "5" },
    move_window_6        = { { "alt", "ctrl" }, "6" },
    move_window_7        = { { "alt", "ctrl" }, "7" },
    move_window_8        = { { "alt", "ctrl" }, "8" },
    move_window_9        = { { "alt", "ctrl" }, "9" },
})

PaperWM:start()

hs.loadSpoon("AutoMuteOnSleep")
hs.loadSpoon("MouseFollowsFocus"):start()
