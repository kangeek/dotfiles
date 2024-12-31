-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

local theme = "Catppuccin Mocha" -- Frappe, Macchiato, Mocha
-- local font = "MesloLGS NF"
-- local font = "JetBrainsMono Nerd Font"
local font = "UbuntuSansMono Nerd Font"

-- This is where you actually apply your config choices

config.term = "tmux-256color"

config.automatically_reload_config = true

-- Use CMD to bypass application mouse reporting (otherwise url in tmux is unclickable)
config.bypass_mouse_reporting_modifiers = "CMD"

config.command_palette_font_size = 17.0
config.command_palette_bg_color = "#1e1e2e"
config.command_palette_fg_color = "#cdd6f4"
config.command_palette_rows = 32

config.default_workspace = "MAC"

config.color_scheme = theme
config.enable_scroll_bar = false
config.font = wezterm.font(font)
config.font_size = 17.0
config.initial_rows = 72
config.initial_cols = 120
config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.inactive_pane_hsb = { brightness = 0.5 }

config.quick_select_patterns = {
	"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", -- ip address
	"\\S+@[\\w\\.]+", -- email address
	"\\w{16,}\\={0,2}", -- base64 encoded string
	"https?://\\S+", -- http(s) url
	'@?"(?:[^"\\\\]|\\\\.)*"', -- quoted string
	"[\\w][\\w-]{8,}", -- general strings
}

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CMD", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "l", mods = "CMD", action = act.ShowLauncher },
	{ key = "m", mods = "CMD", action = wezterm.action.ActivateCommandPalette },
	{ key = "t", mods = "CMD|SHIFT", action = act.ShowTabNavigator },
	{ key = "s", mods = "CMD", action = act.QuickSelect },
	{ key = "y", mods = "CMD", action = act.ActivateCopyMode },
	{ key = "[", mods = "CMD", action = act.ActivatePaneDirection("Left") },
	{ key = "]", mods = "CMD", action = act.ActivatePaneDirection("Right") },

	-- iterm2-like keybindings
	{ key = "d", mods = "CMD", action = act.SplitHorizontal },
	{ key = "d", mods = "CMD|SHIFT", action = act.SplitVertical },
	{ key = "Enter", mods = "CMD|SHIFT", action = act.TogglePaneZoomState },
	{ key = "p", mods = "CMD", action = act.PaneSelect },

	-- tmux-like keybindings
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	-- { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },

	-- Renaming workspace and tabs, https://wezfurlong.org/wezterm/config/lua/keyassignment/PromptInputLine.html
	-- interactively picking a name and creating a new workspace
	{
		key = "n",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- interactively renaming the current tab
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

for i = 1, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "Escape", action = "PopKeyTable" },
	},
}

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false

local function rinder_right_status(icon_text, icon_color, text)
	return {
		"ResetAttributes",
		{ Foreground = { AnsiColor = icon_color } },
		{ Text = " " },
		{ Background = { AnsiColor = icon_color } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = icon_text },
		"ResetAttributes",
		{ Foreground = { AnsiColor = icon_color } },
		{ Text = "█ " },
		"ResetAttributes",
		{ Text = text .. " " },
	}
end

local function concatTables(t1, t2)
	for i = 1, #t2 do
		table.insert(t1, t2[i])
	end
	return t1
end

wezterm.on("update-status", function(window)
	local stat_color = "Blue"
	local workspace_color = "Lime"
	if window:leader_is_active() then
		workspace_color = "Fuchsia"
	end

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({}))

	-- Right status
	window:set_right_status(
		wezterm.format(
			concatTables(
				rinder_right_status(wezterm.nerdfonts.oct_table, workspace_color, window:active_workspace()),
				rinder_right_status(wezterm.nerdfonts.md_timetable, stat_color, wezterm.strftime("%H:%M"))
			)
		)
	)
end)

-- and finally, return the configuration to wezterm
return config
