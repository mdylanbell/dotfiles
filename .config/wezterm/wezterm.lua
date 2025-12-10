local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font("MesloLGMDZ Nerd Font")
config.font_size = 10
-- config.color_scheme = 'Solarized Dark - Patched'
config.color_scheme = "Catppuccin Mocha"

config.default_domain = "WSL:Ubuntu-22.04"

-- To copy just highlight something and right click. Simple
config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = act.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
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

return config
