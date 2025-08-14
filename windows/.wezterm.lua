local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.color_scheme = "Mariana"

config.default_prog = { "powershell.exe", "-NoLogo" }

config.font = wezterm.font("JetBrains Mono", { weight = "Bold", italic = false })
config.font_size = 10

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
