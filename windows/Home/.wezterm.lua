local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()
local act = wezterm.action

-- config.color_scheme = "Mariana"
-- config.color_scheme = "Everforest Dark Medium (Gogh)"
-- config.color_scheme = 'Lab Fox'
-- config.color_scheme = 'Laser'
-- config.color_scheme = "Gruvbox Material (Gogh)"
-- config.color_scheme = 'Grayscale (dark) (terminal.sexy)'
-- config.color_scheme = "GitHub Dark"
-- config.color_scheme = "Neon"
-- config.color_scheme = "Neon Night (Gogh)"
-- config.color_scheme = "Neutron"
-- config.color_scheme = "Neutron (Gogh)"
config.color_scheme = "nightfox"
-- config.color_scheme = "Nord (base16)"

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
-- 	key = "a",
-- 	mods = "CTRL",
-- 	timeout_milliseconds = 2000,
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

-- config.background = {
-- 	{
-- 		source = {
-- 			File = "D:/yandex_disk/pictures/moon.png",
-- 		},
-- 	},
-- }

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_max_width = 32
config.max_fps = 144

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
