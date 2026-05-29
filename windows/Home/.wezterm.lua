local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()
local act = wezterm.action

-- -------------------------- THEMES --------------------------
-- Mariana
-- Everforest Dark Medium (Gogh)
-- Lab Fox
-- Laser
-- Gruvbox Material (Gogh)
-- Grayscale (dark) (terminal.sexy)
-- GitHub Dark
-- Neon
-- Warm Neon
-- Whimsy
-- Neon Night (Gogh)
-- Neutron
-- Neutron (Gogh)
-- nightfox
-- Nord (base16)
-- ------------------------------------------------------------
color_scheme = "Whimsy"
config.color_scheme = color_scheme or ""

-- background_picture = "D:/yandex_disk/pictures/city03.jpg"

-- config.default_prog = { "powershell.exe", "-NoLogo" }
config.default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe", "-NoLogo" }
-- config.default_prog = { "bash" }

config.font = wezterm.font("JetBrains Mono", { weight = "Bold", italic = false })
config.font_size = 10

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

-- config.leader = {
-- 	key = "b",
-- 	mods = "CTRL",
-- 	timeout_milliseconds = 2000,
-- }

-- config.keys = {
-- 	{
-- 		key = "f",
-- 		mods = "ALT",
-- 		action = act.TogglePaneZoomState,
-- 	},
-- 	{
-- 		key = "v",
-- 		mods = "LEADER",
-- 		action = act.SplitPane({
-- 			direction = "Right",
-- 			size = { Percent = 50 },
-- 		}),
-- 	},
-- 	{
-- 		key = "h",
-- 		mods = "ALT",
-- 		action = act.ActivatePaneDirection("Left"),
-- 	},
-- 	{
-- 		key = "l",
-- 		mods = "ALT",
-- 		action = act.ActivatePaneDirection("Right"),
-- 	},
-- }
-- config.keys = {
-- 	{
-- 		key = "c",
-- 		mods = "LEADER",
-- 		action = act.SpawnTab("CurrentPaneDomain"),
-- 	},
-- 	{
-- 		key = "v",
-- 		mods = "LEADER",
-- 		action = act.SplitPane({
-- 			direction = "Right",
-- 			size = { Percent = 50 },
-- 		}),
-- 	},
-- 	{
-- 		key = "h",
-- 		mods = "LEADER",
-- 		action = act.SplitPane({
-- 			direction = "Down",
-- 			size = { Percent = 50 },
-- 		}),
-- 	},
-- 	{
-- 		key = "h",
-- 		mods = "CTRL",
-- 		action = act.EmitEvent("move-left"),
-- 	},
-- }

config.background = {
	{
		source = {
			File = background_picture or "",
		},
	},
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_max_width = 16
config.max_fps = 144

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
