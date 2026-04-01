local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
-- os markers
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_macos = wezterm.target_triple:find("apple%-darwin") ~= nil
local open_link_mods = is_macos and "SUPER" or "CTRL"
-- launch menu vars
local ssh_domains = wezterm.default_ssh_domains()
local launch_menu = {}
local os_launch_menu = {}
local preferred_launch_item

----
-- build launch menu
-- start get ssh config hosts and filter out SSHMUX entries (WezTerm's SSH agent management)
for i = #ssh_domains, 1, -1 do
  if ssh_domains[i].name:find("^SSHMUX:") then
    table.remove(ssh_domains, i)
  end
end

config.ssh_domains = ssh_domains

-- Per OS config for launch menu items, preferred launch item, and default domain
if is_windows then
  -- set default domain
  config.default_domain = "WSL:Ubuntu"
  preferred_launch_item = {
    label = "Preferred (WSL Ubuntu)",
    domain = { DomainName = "WSL:Ubuntu" },
  }
  os_launch_menu = {
    -- { label = "WSL Ubuntu", domain = { DomainName = "WSL:Ubuntu" } },
    { label = "PowerShell 7", domain = { DomainName = "local" }, args = { "pwsh.exe", "-NoLogo" } },
    { label = "Command Prompt", domain = { DomainName = "local" }, args = { "cmd.exe" } },
  }
elseif is_macos then
  preferred_launch_item = {
    label = "Preferred (Local Default Shell)",
    domain = { DomainName = "local" },
  }
else
  preferred_launch_item = {
    label = "Preferred (Local Default Shell)",
    domain = { DomainName = "local" },
  }
end

table.insert(launch_menu, preferred_launch_item)

for _, item in ipairs(os_launch_menu) do
  table.insert(launch_menu, item)
end

config.launch_menu = launch_menu

----
-- general config
config.hide_tab_bar_if_only_one_tab = true

config.initial_cols = 180
config.initial_rows = 65

config.font = wezterm.font("Maple Mono Normal")
-- alternates:
--   config.font = wezterm.font 'MesloLGMDZ Nerd Font'
config.font_size = 10

config.color_scheme = "Catppuccin Mocha"
-- alternates:
--   config.color_scheme = 'Solarized Dark - Patched'

-- Disable WezTerm SSH agent management (lets 1Password own it)
config.mux_enable_ssh_agent = false

-- Disable audible bell
config.audible_bell = "Disabled"

-- Configure cursor flash visual bell
config.visual_bell = {
  fade_in_duration_ms = 40,
  fade_out_duration_ms = 80,
  target = "CursorColor",
}

config.mouse_bindings = {
  -- Keep mouse selection separate from copy; copying stays on explicit keybinds.
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.Nop,
  },
  {
    event = { Up = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.Nop,
  },
  {
    event = { Down = { streak = 3, button = "Left" } },
    mods = "NONE",
    -- triple click selects semantic zone rather than line
    action = act.SelectTextAtMouseCursor("SemanticZone"),
  },
  {
    event = { Up = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.Nop,
  },
  -- Open links explicitly to avoid accidental launches while selecting text.
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = open_link_mods,
    action = act.Nop,
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = open_link_mods,
    action = act.OpenLinkAtMouseCursor,
  },
}

-- Explicit copy/paste bindings (terminal-level)
config.keys = {
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  {
    key = "l",
    mods = "CTRL|ALT",
    action = act.ShowLauncherArgs({
      flags = "LAUNCH_MENU_ITEMS|DOMAINS",
    }),
  },
  {
    key = "o",
    mods = "CTRL|SHIFT",
    action = act.QuickSelectArgs({
      label = "open url",
      patterns = {
        "https?://\\S+",
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        if url ~= "" then
          wezterm.open_with(url)
        end
      end),
    }),
  },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
}

return config
