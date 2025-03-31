-- local wezterm = require 'wezterm'

-- -- This will hold the configuration.
-- local config = wezterm.config_builder()
-- local mux    = wezterm.mux
-- local wsl_domains = wezterm.default_wsl_domains()

-- -- This is where you actually apply your config choices
-- wezterm.on("gui-startup", function(cmd)
    -- local tab, pane, window = mux.spawn_window(cmd or {})
    -- window:gui_window():maximize()
-- end)

-- wezterm.on('update-right-status', function(window, pane)
    -- local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'

    -- -- Make it italic and underlined
    -- window:set_right_status(wezterm.format {
        -- { Attribute = { Underline = 'Single' } },
        -- { Attribute = { Italic = true } },
        -- { Attribute = { Intensity = 'Bold' } },
        -- { Foreground = { AnsiColor = 'Fuchsia' } },
        -- { Text = window:active_workspace() },
        -- { Text = '   ' },
        -- { Text = date },
    -- })
-- end)


-- -- For example, changing the color scheme:
-- -- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Oceanic Next (Gogh)'
-- config.scrollback_lines = 3500
-- config.default_domain = 'WSL:workspace'
-- config.default_prog = {'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', '-NoLogo'}
-- config.default_cwd  = "$HOME"
-- config.launch_menu = {}
-- config.window_close_confirmation = 'NeverPrompt'
-- config.skip_close_confirmation_for_processes_named = {}

-- -- This is my chosen font, we will get into installing fonts on windows later
-- config.font = wezterm.font('Cascadia Code')
-- config.font_size = 11

-- config.text_background_opacity = 0.5
-- config.window_background_image = 'C:\\Users\\doomc\\Desktop\\moon.jpg'

-- config.leader = { key = 's', mods = 'ALT', timeout_milliseconds = 1000 }
-- config.keys = {
  -- {
    -- mods   = "LEADER",
    -- key    = "-",
    -- action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  -- },
  -- {
    -- mods   = "LEADER",
    -- key    = "=",
    -- action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  -- },
  -- {
    -- mods = 'LEADER',
    -- key = 'm',
    -- action = wezterm.action.TogglePaneZoomState
  -- },
  -- {
    -- mods = "LEADER",
    -- key = "Space",
    -- action = wezterm.action.RotatePanes "Clockwise"
  -- },
  -- {
    -- mods = 'LEADER',
    -- key = '0',
    -- action = wezterm.action.PaneSelect {
      -- mode = 'SwapWithActive',
    -- }
  -- },
  -- {
    -- key = 'Enter',
    -- mods = 'LEADER',
    -- action = wezterm.action.ActivateCopyMode
  -- },
  -- {
      -- key = "c",
      -- mods = "LEADER",
      -- action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  -- },
  -- -- {
      -- -- key = 'p',
      -- -- mods = 'CTRL|SHIFT',
      -- -- action = wezterm.action.SpawnTab {'PowerShell'},
  -- -- }
-- }

-- return config

-- Pull in the wezterm API
-- local os              = require 'os'
-- local wezterm         = require 'wezterm'
-- local session_manager = require 'wezterm-session-manager/session-manager'
-- local act             = wezterm.action
-- local mux             = wezterm.mux

-- -- --------------------------------------------------------------------
-- -- FUNCTIONS AND EVENT BINDINGS
-- -- --------------------------------------------------------------------

-- -- Session Manager event bindings
-- -- See https://github.com/danielcopper/wezterm-session-manager
-- wezterm.on("save_session", function(window) session_manager.save_state(window) end)
-- wezterm.on("load_session", function(window) session_manager.load_state(window) end)
-- wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

-- -- Wezterm <-> nvim pane navigation
-- -- You will need to install https://github.com/aca/wezterm.nvim
-- -- and ensure you export NVIM_LISTEN_ADDRESS per the README in that repo

-- local move_around = function(window, pane, direction_wez, direction_nvim)
    -- local result = os.execute("env NVIM_LISTEN_ADDRESS=/tmp/nvim" .. pane:pane_id() .. " " .. wezterm.home_dir .. "/.local/bin/wezterm.nvim.navigator" .. " " .. direction_nvim)
    -- if result then
		-- window:perform_action(
            -- act({ SendString = "\x17" .. direction_nvim }),
            -- pane
        -- )
    -- else
        -- window:perform_action(
            -- act({ ActivatePaneDirection = direction_wez }),
            -- pane
        -- )
    -- end
-- end

-- wezterm.on("move-left", function(window, pane)
	-- move_around(window, pane, "Left", "h")
-- end)

-- wezterm.on("move-right", function(window, pane)
	-- move_around(window, pane, "Right", "l")
-- end)

-- wezterm.on("move-up", function(window, pane)
	-- move_around(window, pane, "Up", "k")
-- end)

-- wezterm.on("move-down", function(window, pane)
	-- move_around(window, pane, "Down", "j")
-- end)

-- local vim_resize = function(window, pane, direction_wez, direction_nvim)
	-- local result = os.execute(
		-- "env NVIM_LISTEN_ADDRESS=/tmp/nvim"
			-- .. pane:pane_id()
			-- .. " "
            -- .. wezterm.home_dir
			-- .. "/.local/bin/wezterm.nvim.navigator"
			-- .. " "
			-- .. direction_nvim
	-- )
	-- if result then
		-- window:perform_action(act({ SendString = "\x1b" .. direction_nvim }), pane)
	-- else
		-- window:perform_action(act({ ActivatePaneDirection = direction_wez }), pane)
	-- end
-- end

-- wezterm.on("resize-left", function(window, pane)
	-- vim_resize(window, pane, "Left", "h")
-- end)

-- wezterm.on("resize-right", function(window, pane)
	-- vim_resize(window, pane, "Right", "l")
-- end)

-- wezterm.on("resize-up", function(window, pane)
	-- vim_resize(window, pane, "Up", "k")
-- end)

-- wezterm.on("resize-down", function(window, pane)
	-- vim_resize(window, pane, "Down", "j")
-- end)

-- -- --------------------------------------------------------------------
-- -- CONFIGURATION
-- -- --------------------------------------------------------------------

-- -- This table will hold the configuration.
-- local config = {}

-- -- In newer versions of wezterm, use the config_builder which will
-- -- help provide clearer error messages
-- if wezterm.config_builder then
  -- config = wezterm.config_builder()
-- end

-- config.adjust_window_size_when_changing_font_size = false
-- config.automatically_reload_config = true
-- config.color_scheme = 'Solarized (dark) (terminal.sexy)'
-- config.enable_scroll_bar = true
-- config.enable_wayland = true
-- -- config.font = wezterm.font('Hack')
-- config.font = wezterm.font('Monaspace Neon')
-- config.font_size = 12.0
-- config.hide_tab_bar_if_only_one_tab = true
-- -- The leader is similar to how tmux defines a set of keys to hit in order to
-- -- invoke tmux bindings. Binding to ctrl-a here to mimic tmux
-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
-- config.mouse_bindings = {
    -- -- Open URLs with Ctrl+Click
    -- {
        -- event = { Up = { streak = 1, button = 'Left' } },
        -- mods = 'CTRL',
        -- action = act.OpenLinkAtMouseCursor,
    -- }
-- }
-- config.pane_focus_follows_mouse = true
-- config.scrollback_lines = 5000
-- config.use_dead_keys = false
-- config.warn_about_missing_glyphs = false
-- config.window_decorations = 'TITLE | RESIZE'
-- config.window_padding = {
    -- left = 0,
    -- right = 0,
    -- top = 0,
    -- bottom = 0,
-- }

-- -- Tab bar
-- config.use_fancy_tab_bar = true
-- config.tab_bar_at_bottom = true
-- config.switch_to_last_active_tab_when_closing_tab = true
-- config.tab_max_width = 32
-- config.colors = {
    -- tab_bar = {
        -- active_tab = {
            -- fg_color = '#073642',
            -- bg_color = '#2aa198',
        -- }
    -- }
-- }

-- -- Setup muxing by default
-- config.unix_domains = {
  -- {
    -- name = 'unix',
  -- },
-- }

-- -- Custom key bindings
-- config.keys = {
    -- -- -- Disable Alt-Enter combination (already used in tmux to split pane)
    -- -- {
    -- --     key = 'Enter',
    -- --     mods = 'ALT',
    -- --     action = act.DisableDefaultAssignment,
    -- -- },

    -- -- Copy mode
    -- {
        -- key = '[',
        -- mods = 'LEADER',
        -- action = act.ActivateCopyMode,
    -- },

    -- -- ----------------------------------------------------------------
    -- -- TABS
    -- --
    -- -- Where possible, I'm using the same combinations as I would in tmux
    -- -- ----------------------------------------------------------------

    -- -- Show tab navigator; similar to listing panes in tmux
    -- {
        -- key = 'w',
        -- mods = 'LEADER',
        -- action = act.ShowTabNavigator,
    -- },
    -- -- Create a tab (alternative to Ctrl-Shift-Tab)
    -- {
        -- key = 'c',
        -- mods = 'LEADER',
        -- action = act.SpawnTab 'CurrentPaneDomain',
    -- },
    -- -- Rename current tab; analagous to command in tmux
    -- {
        -- key = ',',
        -- mods = 'LEADER',
        -- action = act.PromptInputLine {
            -- description = 'Enter new name for tab',
            -- action = wezterm.action_callback(
                -- function(window, pane, line)
                    -- if line then
                        -- window:active_tab():set_title(line)
                    -- end
                -- end
            -- ),
        -- },
    -- },
    -- -- Move to next/previous TAB
    -- {
        -- key = 'n',
        -- mods = 'LEADER',
        -- action = act.ActivateTabRelative(1),
    -- },
    -- {
        -- key = 'p',
        -- mods = 'LEADER',
        -- action = act.ActivateTabRelative(-1),
    -- },
    -- -- Close tab
    -- {
        -- key = '&',
        -- mods = 'LEADER|SHIFT',
        -- action = act.CloseCurrentTab{ confirm = true },
    -- },

    -- -- ----------------------------------------------------------------
    -- -- PANES
    -- --
    -- -- These are great and get me most of the way to replacing tmux
    -- -- entirely, particularly as you can use "wezterm ssh" to ssh to another
    -- -- server, and still retain Wezterm as your terminal there.
    -- -- ----------------------------------------------------------------

    -- -- -- Vertical split
    -- {
        -- -- |
        -- key = '|',
        -- mods = 'LEADER|SHIFT',
        -- action = act.SplitPane {
            -- direction = 'Right',
            -- size = { Percent = 50 },
        -- },
    -- },
    -- -- Horizontal split
    -- {
        -- -- -
        -- key = '-',
        -- mods = 'LEADER',
        -- action = act.SplitPane {
            -- direction = 'Down',
            -- size = { Percent = 50 },
        -- },
    -- },
    -- -- CTRL + (h,j,k,l) to move between panes
    -- {
        -- key = 'h',
        -- mods = 'CTRL',
        -- action = act({ EmitEvent = "move-left" }),
    -- },
    -- {
        -- key = 'j',
        -- mods = 'CTRL',
        -- action = act({ EmitEvent = "move-down" }),
    -- },
    -- {
        -- key = 'k',
        -- mods = 'CTRL',
        -- action = act({ EmitEvent = "move-up" }),
    -- },
    -- {
        -- key = 'l',
        -- mods = 'CTRL',
        -- action = act({ EmitEvent = "move-right" }),
    -- },
    -- -- ALT + (h,j,k,l) to resize panes
    -- {
        -- key = 'h',
        -- mods = 'ALT',
        -- action = act({ EmitEvent = "resize-left" }),
    -- },
    -- {
        -- key = 'j',
        -- mods = 'ALT',
        -- action = act({ EmitEvent = "resize-down" }),
    -- },
    -- {
        -- key = 'k',
        -- mods = 'ALT',
        -- action = act({ EmitEvent = "resize-up" }),
    -- },
    -- {
        -- key = 'l',
        -- mods = 'ALT',
        -- action = act({ EmitEvent = "resize-right" }),
    -- },
    -- -- Close/kill active pane
    -- {
        -- key = 'x',
        -- mods = 'LEADER',
        -- action = act.CloseCurrentPane { confirm = true },
    -- },
    -- -- Swap active pane with another one
    -- {
        -- key = '{',
        -- mods = 'LEADER|SHIFT',
        -- action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" },
    -- },
    -- -- Zoom current pane (toggle)
    -- {
        -- key = 'z',
        -- mods = 'LEADER',
        -- action = act.TogglePaneZoomState,
    -- },
    -- {
        -- key = 'f',
        -- mods = 'ALT',
        -- action = act.TogglePaneZoomState,
    -- },
    -- -- Move to next/previous pane
    -- {
        -- key = ';',
        -- mods = 'LEADER',
        -- action = act.ActivatePaneDirection('Prev'),
    -- },
    -- {
        -- key = 'o',
        -- mods = 'LEADER',
        -- action = act.ActivatePaneDirection('Next'),
    -- },

    -- -- ----------------------------------------------------------------
    -- -- Workspaces
    -- --
    -- -- These are roughly equivalent to tmux sessions.
    -- -- ----------------------------------------------------------------

    -- -- Attach to muxer
    -- {
        -- key = 'a',
        -- mods = 'LEADER',
        -- action = act.AttachDomain 'unix',
    -- },

    -- -- Detach from muxer
    -- {
        -- key = 'd',
        -- mods = 'LEADER',
        -- action = act.DetachDomain { DomainName = 'unix' },
    -- },

    -- -- Show list of workspaces
    -- {
        -- key = 's',
        -- mods = 'LEADER',
        -- action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
    -- },
    -- -- Rename current session; analagous to command in tmux
    -- {
        -- key = '$',
        -- mods = 'LEADER|SHIFT',
        -- action = act.PromptInputLine {
            -- description = 'Enter new name for session',
            -- action = wezterm.action_callback(
                -- function(window, pane, line)
                    -- if line then
                        -- mux.rename_workspace(
                            -- window:mux_window():get_workspace(),
                            -- line
                        -- )
                    -- end
                -- end
            -- ),
        -- },
    -- },

    -- -- Session manager bindings
    -- {
        -- key = 's',
        -- mods = 'LEADER|SHIFT',
        -- action = act({ EmitEvent = "save_session" }),
    -- },
    -- {
        -- key = 'L',
        -- mods = 'LEADER|SHIFT',
        -- action = act({ EmitEvent = "load_session" }),
    -- },
    -- {
        -- key = 'R',
        -- mods = 'LEADER|SHIFT',
        -- action = act({ EmitEvent = "restore_session" }),
    -- },
-- }

-- -- and finally, return the configuration to wezterm
-- return config


-- These are the basic's for using wezterm.
-- Mux is the mutliplexes for windows etc inside of the terminal
-- Action is to perform actions on the terminal
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

-- These are vars to put things in later (i dont use em all yet)
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- This is for newer wezterm vertions to use the config builder 
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Default config settings
-- These are the default config settins needed to use Wezterm
-- Just add this and return config and that's all the basics you need

-- Color scheme, Wezterm has 100s of them you can see here:
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'Oceanic Next (Gogh)'
-- This is my chosen font, we will get into installing fonts on windows later
config.font = wezterm.font('JetBrains Mono')
config.font_size = 10
config.launch_menu = launch_menu
-- makes my cursor blink 
config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true
-- this adds the ability to use ctrl+v to paste the system clipboard 
config.keys = {{ key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },}
config.mouse_bindings = mouse_bindings

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
 {
  event = { Down = { streak = 1, button = "Right" } },
  mods = "NONE",
  action = wezterm.action_callback(function(window, pane)
   local has_selection = window:get_selection_text_for_pane(pane) ~= ""
   if has_selection then
    window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
    window:perform_action(act.ClearSelection, pane)
   else
    window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
   end
  end),
 },
}

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.2,
  brightness = 1.5,
}

-- This is used to set an image as my background 
config.background = {
    {
        source = { File = {path = 'C:/Users/doomc/Desktop/moon.png', speed = 0.2}},
 opacity = 1,
 width = "100%",
 hsb = {brightness = 0.5},
    }
}

-- IMPORTANT: Sets WSL2 UBUNTU-22.04 as the defualt when opening Wezterm
config.default_domain = 'WSL:workspace'

return config