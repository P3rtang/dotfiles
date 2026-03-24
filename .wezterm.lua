-- Pull in the wezterm API
local wezterm = require 'wezterm'
local theme = require 'theme'
local session_manager = require("wezterm-session-manager\\session-manager")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font "Comic Mono"
config.font_size = 13
config.line_height = 1.1

config.default_prog = { 'powershell.exe' }

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
    {
        key = 'r',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ReloadConfiguration,
    },
    {
        key = 'p',
        mods = 'ALT',
        action = wezterm.action.ShowLauncher,
    },
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
    },
    {
        key = "S",
        mods = "LEADER",
        action = wezterm.action{EmitEvent = "save_session"}
    },
    {
        key = "L",
        mods = "LEADER",
        action = wezterm.action{EmitEvent = "load_session"}
    },
    {
        key = "R",
        mods = "LEADER",
        action = wezterm.action{EmitEvent = "restore_session"}
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Down')
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Up')
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Left')
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Right')
    }
}

config.launch_menu = {
    {
        label = "MSYS2",
        args = { 'C:\\msys64\\usr\\bin\\bash.exe', '--login' },
    },
}

for i = 1, 9 do
    -- ALT + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'ALT',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
config.window_background_opacity = 0.85
config.win32_system_backdrop = 'Acrylic'

wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

local wezterm = require 'wezterm';

-- and finally, return the configuration to wezterm
return config
