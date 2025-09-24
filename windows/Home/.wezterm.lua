local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

-- config.color_scheme = "Mariana"
-- config.color_scheme = "Everforest Dark Medium (Gogh)"
-- config.color_scheme = "Lab Fox"
-- config.color_scheme = "Laser"
config.color_scheme = "Gruvbox Material (Gogh)"

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

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
